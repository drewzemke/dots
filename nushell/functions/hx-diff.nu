# write a jj diff to a temp file and print its path, for `:open` in helix
#
# each mode prefixes the diff with a `# ` commented header describing the
# revision(s) involved; `line` mode renders a full blame block

const tmp = "/tmp/hx-diff"

# full metadata block for one revision, already `# ` prefixed
const info_template = '
  "# change    " ++ change_id.short(12) ++ "   commit " ++ commit_id.short(12) ++ "\n" ++
  "# author    " ++ author.name() ++ " <" ++ author.email() ++ ">\n" ++
  "# date      " ++ author.timestamp().local().format("%Y-%m-%d %H:%M") ++
    " (" ++ author.timestamp().ago() ++ ")\n" ++
  if(bookmarks, "# bookmarks " ++ bookmarks.join(", ") ++ "\n") ++
  "#\n" ++
  if(description, indent("# ", description), "# (no description set)\n")
'

const oneline_template = '
  change_id.short(12) ++ "  " ++
  if(description, description.first_line(), "(no description set)")
'

def info [rev: string]: nothing -> string {
  jj log --no-graph -r $rev -T $info_template | complete | get stdout
}

def oneline [rev: string]: nothing -> string {
  jj log --no-graph -r $rev -T $oneline_template | complete | get stdout | str trim
}

# `from -> to` summary for the whole-file modes
def endpoints [from: string, to: string]: nothing -> string {
  $"# from      ($from | fill -w 8)  (oneline $from)\n# to        ($to | fill -w 8)  (oneline $to)\n"
}

def emit [slug: string, header: string, result: record]: nothing -> string {
  mkdir $tmp
  let path = $"($tmp)/($slug).diff"
  let body = if $result.exit_code != 0 {
    $result.stderr
  } else if ($result.stdout | str trim | is-empty) {
    "no changes\n"
  } else {
    $result.stdout
  }
  $"($header)\n($body)" | save -f $path
  $path
}

def fail [slug: string, header: string, msg: string]: nothing -> string {
  emit $slug $header {exit_code: 1, stdout: "", stderr: $msg}
}

# diff of the commit that last touched the given line
def at-line [file: string, line: int]: nothing -> string {
  let slug = $"(slug $file)@line"
  let title = $"# ($file):($line)\n"
  let annotated = (jj file annotate -T 'commit.change_id().short(12) ++ "\t" ++ content' $file | complete)
  if $annotated.exit_code != 0 {
    return (fail $slug $title $annotated.stderr)
  }
  let rows = ($annotated.stdout | lines)
  if $line < 1 or $line > ($rows | length) {
    return (fail $slug $title $"line ($line) is out of range \(file has ($rows | length) lines)\n")
  }
  let parts = ($rows | get ($line - 1) | split row --number 2 "\t")
  let id = ($parts | first)
  let text = ($parts | get 1? | default "")
  let header = $"($title)# ($line) | ($text)\n#\n(info $id)"
  emit $"(slug $file)@($id)" $header (jj diff -r $id | complete)
}

def slug [file: string]: nothing -> string {
  $file | str replace --all --regex '[/ ]' '-'
}

# mode is one of: parent, trunk, line
export def main [mode: string, file: string, line?: int]: nothing -> string {
  match $mode {
    "parent" => (emit $"(slug $file)@parent"
      $"# ($file)\n#\n(endpoints '@-' '@')"
      (jj diff $file | complete))
    "trunk" => (emit $"(slug $file)@trunk"
      $"# ($file)\n#\n(endpoints 'trunk()' '@')"
      (jj diff --from 'trunk()' $file | complete))
    "line" => (at-line $file ($line | default 1))
    _ => (error make {msg: $"unknown mode: ($mode)"})
  }
}
