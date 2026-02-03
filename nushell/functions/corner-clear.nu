# clear current tab from the claude notification corner
#
# useful when claude is closed before taking an action that would clear it

use corner-update.nu

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

  corner-update
}
