# manage icons on zellij tab names

const ICONS = {
  action: "⚡"
  working: "⏳"
  done: "✅"
  error: "❌"
  server: "🌐"
}

def get-pane [] {
  zellij action list-panes --tab --json
    | from json
    | where id == ($env.ZELLIJ_PANE_ID | into int)
    | first
}

def resolve [name: string] {
  $ICONS | get $name
}

# apply a batch of icon operations as a single tab rename
# usage: tab-mark "rm action, rm working, add done"
export def main [ops: string] {
  if "ZELLIJ_PANE_ID" not-in $env { return }
  let pane = get-pane
  mut name = $pane.tab_name

  for op in ($ops | split row "," | each { str trim }) {
    let parts = ($op | split row " ")
    let action = $parts.0

    if $action == "clear" {
      $name = ($name | str replace --regex '^[^\x00-\x7F]+' '')
      continue
    }

    let icon = resolve $parts.1

    if $action == "add" {
      if not ($name | str contains $icon) {
        $name = $"($icon)($name)"
      }
    } else if $action == "rm" {
      $name = ($name | str replace --all $icon "")
    }
  }

  if $name != $pane.tab_name {
    zellij action rename-tab --tab-id $pane.tab_id $name
  }
}
