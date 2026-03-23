# mark/unmark zellij tabs when claude needs attention

const MARKER = "⚡"

def get-pane [] {
  zellij action list-panes --tab --json
    | from json
    | where id == ($env.ZELLIJ_PANE_ID | into int)
    | first
}

# add marker to tab name
export def main [] {
  if "ZELLIJ_PANE_ID" not-in $env { return }
  let pane = get-pane
  if not ($pane.tab_name | str starts-with $MARKER) {
    zellij action rename-tab --tab-id $pane.tab_id $"($MARKER)($pane.tab_name)"
  }
}

# remove marker from tab name
export def clear [] {
  if "ZELLIJ_PANE_ID" not-in $env { return }
  let pane = get-pane
  if ($pane.tab_name | str starts-with $MARKER) {
    zellij action rename-tab --tab-id $pane.tab_id ($pane.tab_name | str replace $MARKER "")
  }
}
