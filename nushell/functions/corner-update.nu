# corner renderer for github notifications + now playing
#
# reads state from:
#   /tmp/github-notifications.nuon - { fetched_at, counts: { pr, ci, ... } }
#   /tmp/now-playing.nuon - { fetched_at, playing, title, artist }

const GH_SYMBOL = $" (ansi yellow)  (ansi reset)"
const MEDIA_PLAYING = $"(ansi yellow)  (ansi reset)"
const MEDIA_PAUSED = $"(ansi yellow)󰏦  (ansi reset)"
const GITHUB_FILE = "/tmp/github-notifications.nuon"
const MEDIA_FILE = "/tmp/now-playing.nuon"

def read-github [] {
  if ($GITHUB_FILE | path exists) {
    try {
      (open $GITHUB_FILE).counts? | default {}
    } catch {
      {}
    }
  } else {
    {}
  }
}

def format-github [counts: record] {
  $counts
    | items { |k, v| if ($v | into int) > 0 { $"($k):($v)" } }
    | where { $in != null }
    | str join " "
}

def read-media [] {
  if ($MEDIA_FILE | path exists) {
    try {
      open $MEDIA_FILE
    } catch {
      null
    }
  } else {
    null
  }
}

def format-media [] {
  let state = read-media
  if ($state == null) or ($state.title? | default "" | is-empty) {
    ""
  } else {
    let icon = if ($state.playing? | default false) { $MEDIA_PLAYING } else { $MEDIA_PAUSED }
    $"($icon)($state.title) — ($state.artist)"
  }
}

export def main [] {
  let github_part = format-github (read-github)
  let media_part = format-media

  let parts = [
    (if ($media_part | is-not-empty) { $media_part })
    (if ($github_part | is-not-empty) { $"($GH_SYMBOL)($github_part)" })
  ] | where { $in != null }

  let msg = if ($parts | is-empty) { " " } else { $parts | str join "  " }

  zellij pipe $"zjstatus::pipe::pipe_corner::($msg)"
}
