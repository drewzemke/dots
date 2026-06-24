# manage icons on zellij tab names

def get-pane [] {
  zellij action list-panes --tab --json
    | from json
    | where id == ($env.ZELLIJ_PANE_ID | into int)
    | first
}

# add an icon to the tab name (idempotent)
export def add [icon: string] {
  if "ZELLIJ_PANE_ID" not-in $env { return }
  let pane = get-pane
  if ($pane.tab_name | str contains $icon) { return }
  zellij action rename-tab --tab-id $pane.tab_id $"($icon)($pane.tab_name)"
}

# remove an icon from the tab name
export def rm [icon: string] {
  if "ZELLIJ_PANE_ID" not-in $env { return }
  let pane = get-pane
  if not ($pane.tab_name | str contains $icon) { return }
  zellij action rename-tab --tab-id $pane.tab_id ($pane.tab_name | str replace --all $icon "")
}

# remove all icons from the tab name
export def clear [] {
  if "ZELLIJ_PANE_ID" not-in $env { return }
  let pane = get-pane
  # strip leading emoji/non-ascii characters
  let clean = $pane.tab_name | str replace --regex '^[^\x00-\x7F]+' ''
  if $clean != $pane.tab_name {
    zellij action rename-tab --tab-id $pane.tab_id $clean
  }
}
