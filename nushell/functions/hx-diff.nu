# write a jj diff to a temp file and print its path, for `:open` in helix

const tmp = "/tmp/hx-diff"

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
  $"# ($header)\n\n($body)" | save -f $path
  $path
}

def slug [file: string]: nothing -> string {
  $file | str replace --all --regex '[/ ]' '-'
}

# diff of the commit that last touched the given line
def at-line [file: string, line: int]: nothing -> string {
  let annotated = (jj file annotate -T 'commit.change_id().short() ++ "\n"' $file | complete)
  if $annotated.exit_code != 0 {
    return (emit $"(slug $file)@line" $"($file):($line)" $annotated)
  }
  let ids = ($annotated.stdout | lines)
  if $line < 1 or $line > ($ids | length) {
    return (emit $"(slug $file)@line" $"($file):($line)"
      {exit_code: 1, stdout: "", stderr: $"line ($line) out of range\n"})
  }
  let id = ($ids | get ($line - 1))
  let desc = (jj log --no-graph -r $id -T 'description.first_line()' | complete | get stdout)
  emit $"(slug $file)@($id)" $"($file):($line) last changed in ($id) ($desc)" (jj diff -r $id | complete)
}

# mode is one of: parent, trunk, line
export def main [mode: string, file: string, line?: int]: nothing -> string {
  match $mode {
    "parent" => (emit $"(slug $file)@parent" $"($file): @- -> @" (jj diff $file | complete))
    "trunk" => (emit $"(slug $file)@trunk" $"($file): trunk\() -> @"
      (jj diff --from 'trunk()' $file | complete))
    "line" => (at-line $file ($line | default 1))
    _ => (error make {msg: $"unknown mode: ($mode)"})
  }
}
