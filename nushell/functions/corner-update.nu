# corner renderer for github notifications
#
# reads state from:
#   /tmp/github-notifications.nuon - { fetched_at, counts: { pr, ci, ... } }

const GH_SYMBOL = $"(ansi yellow) (ansi reset)"
const GITHUB_FILE = "/tmp/github-notifications.nuon"

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

export def main [] {
  let github_part = format-github (read-github)
  let msg = if ($github_part | is-not-empty) {
    $"($GH_SYMBOL) ($github_part)"
  } else {
    " "
  }

  zellij pipe $"zjstatus::pipe::pipe_corner::($msg)"
}
