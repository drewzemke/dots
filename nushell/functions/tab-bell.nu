# show a notification in zjstatus corner when claude needs attention
#
# tracks pending tabs in a shared file so multiple instances work together
# corner shows all pending tabs, e.g. "✨ dots, forms"

use corner-update.nu

const PENDING_FILE = "/tmp/claude-pending-tabs"

# per-instance file to remember which tab this claude is in
def tab-file [] {
  $"/tmp/claude-tab-($env.ZELLIJ_PANE_ID)"
}

def current-tab-name [] {
  # dump-layout outputs KDL with tab info like:
  #   tab name="dots" focus=true hide_floating_panes=true {
  # the focused tab has focus=true, so we grep for that line
  # then parse out just the name between quotes
  zellij action dump-layout
    | lines
    | find 'focus=true'
    | first
    | parse --regex 'tab name="(?<name>[^"]+)"'
    | get name
    | first
}

def read-pending [] {
  if ($PENDING_FILE | path exists) {
    open $PENDING_FILE | lines | where {|l| $l | is-not-empty }
  } else {
    []
  }
}

def write-pending [tabs: list<string>] {
  if ($tabs | is-empty) {
    rm -f $PENDING_FILE
  } else {
    $tabs | str join "\n" | save --force $PENDING_FILE
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
      let pending = read-pending
      if not ($name in $pending) {
        write-pending ($pending | append $name)
      }
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
      let pending = read-pending | where {|t| $t != $name }
      write-pending $pending
      corner-update
    }
  }
}
