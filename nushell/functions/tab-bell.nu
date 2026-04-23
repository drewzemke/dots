# mark/unmark zellij tabs with status emoji

const EMOJI = {
  attention: "⚡"
  working: "⏳"
  done: "✅"
  error: "❌"
}

const ALL_MARKERS = [$EMOJI.attention, $EMOJI.working, $EMOJI.done, $EMOJI.error]

def get-pane [] {
  zellij action list-panes --tab --json
    | from json
    | where id == ($env.ZELLIJ_PANE_ID | into int)
    | first
}

def strip-markers [name: string] {
  mut result = $name
  for marker in $ALL_MARKERS {
    $result = ($result | str replace $marker "")
  }
  $result
}

def set-marker [marker: string] {
  if "ZELLIJ_PANE_ID" not-in $env { return }
  let pane = get-pane
  let clean = strip-markers $pane.tab_name
  zellij action rename-tab --tab-id $pane.tab_id $"($marker)($clean)"
}

# needs attention (permission prompt)
export def main [] {
  set-marker $EMOJI.attention
}

# claude is working
export def working [] {
  set-marker $EMOJI.working
}

# claude finished, no action needed
export def done [] {
  set-marker $EMOJI.done
}

# claude hit an error
export def error [] {
  set-marker $EMOJI.error
}

# remove all markers from tab name
export def clear [] {
  if "ZELLIJ_PANE_ID" not-in $env { return }
  let pane = get-pane
  let clean = strip-markers $pane.tab_name
  if $clean != $pane.tab_name {
    zellij action rename-tab --tab-id $pane.tab_id $clean
  }
}

