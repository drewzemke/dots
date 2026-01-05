# clear current tab from the claude notification corner
#
# useful when claude is closed before taking an action that would clear it

const BELL = "✨"
const PENDING_FILE = "/tmp/claude-pending-tabs"

def current-tab-name [] {
  zellij action dump-layout
    | lines
    | find 'focus=true'
    | first
    | parse --regex 'tab name="(?<name>[^"]+)"'
    | get name
    | first
}

export def main [] {
  let name = current-tab-name

  # remove from pending list
  if ($PENDING_FILE | path exists) {
    let pending = (open $PENDING_FILE | lines | where {|t| ($t != $name) and ($t | is-not-empty) })
    if ($pending | is-empty) {
      rm -f $PENDING_FILE
    } else {
      $pending | str join "\n" | save --force $PENDING_FILE
    }
  }

  # update corner
  let tabs = if ($PENDING_FILE | path exists) {
    open $PENDING_FILE | lines | where {|l| $l | is-not-empty }
  } else {
    []
  }

  if ($tabs | is-empty) {
    zellij pipe zjstatus::pipe::pipe_corner::' '
  } else {
    let msg = $"($BELL) ($tabs | str join ', ')"
    zellij pipe zjstatus::pipe::pipe_corner::($msg)
  }
}
