# show a notification in zjstatus corner when claude needs attention
#
# tracks pending tabs using per-tab files so multiple instances can't
# clobber each other. corner shows all pending tabs, e.g. "✨ dots, forms"

use corner-update.nu

const PENDING_DIR = "/tmp/claude-pending"

# per-instance file to remember which tab this claude is in
def tab-file [] {
  $"/tmp/claude-tab-($env.ZELLIJ_PANE_ID)"
}

def current-tab-name [] {
  # find our tab by matching cwd + "claude" in the layout dump.
  # using focus=true would return whichever tab the user is looking at,
  # which may differ from ours if they switched tabs during startup.
  let lines = zellij action dump-layout | lines | enumerate

  try {
    let root = ($lines
      | where {|r| $r.item =~ '^\s+cwd '}
      | get 0.item
      | parse --regex 'cwd "(?<p>[^"]+)"'
      | get 0.p)

    let rel = ($env.PWD | str replace $"($root)/" "")
    let cwd_pattern = $'cwd="($rel)"'

    let pane_idx = ($lines
      | where {|r| ($r.item | str contains "claude") and ($r.item | str contains $cwd_pattern)}
      | get 0.index)

    $lines
      | where {|r| ($r.index < $pane_idx) and ($r.item =~ 'tab name=')}
      | last
      | get item
      | parse --regex 'tab name="(?<n>[^"]+)"'
      | get 0.n
  } catch {
    # fallback: focused tab
    $lines
      | get item
      | find 'focus=true'
      | first
      | parse --regex 'tab name="(?<name>[^"]+)"'
      | get name
      | first
  }
}

def read-pending [] {
  if ($PENDING_DIR | path exists) {
    ls $PENDING_DIR | get name | each { path basename }
  } else {
    []
  }
}

def add-pending [name: string] {
  mkdir $PENDING_DIR
  "" | save --force ($PENDING_DIR | path join $name)
}

def remove-pending [name: string] {
  let f = ($PENDING_DIR | path join $name)
  if ($f | path exists) { rm -f $f }
  if ($PENDING_DIR | path exists) and (ls $PENDING_DIR | is-empty) {
    rm -rf $PENDING_DIR
  }
}


# save current tab name to temp file (call on session start)
export def init [] {
  current-tab-name | save --force (tab-file)
}

# add this tab to pending list and update corner (call on notification)
export def main [] {
  let file = tab-file
  if ($file | path exists) {
    let name = open $file | str trim
    if ($name | is-not-empty) {
      add-pending $name
      corner-update
    }
  }
}

# remove this tab from pending list and update corner (call on user interaction)
export def clear [] {
  let file = tab-file
  if ($file | path exists) {
    let name = open $file | str trim
    if ($name | is-not-empty) {
      remove-pending $name
      corner-update
    }
  }
}
