# shared corner renderer - combines all notification sources
#
# reads state from:
#   /tmp/claude-pending-tabs     - newline-separated tab names
#   /tmp/github-notifications.nuon - { fetched_at, counts: { pr, ci, ... } }

const CLAUDE_SYMBOL = $"(ansi yellow) (ansi reset)"
const GH_SYMBOL = $"(ansi yellow) (ansi reset)"

const CLAUDE_FILE = "/tmp/claude-pending-tabs"
const GITHUB_FILE = "/tmp/github-notifications.nuon"

def read-claude [] {
  if ($CLAUDE_FILE | path exists) {
    open $CLAUDE_FILE | lines | where { $in | is-not-empty }
  } else {
    []
  }
}

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
  # format non-zero counts as "pr:2 @:1"
  $counts
    | items { |k, v| if ($v | into int) > 0 { $"($k):($v)" } }
    | where { $in != null }
    | str join " "
}

export def main [] {
  let claude_tabs = read-claude
  let github_counts = read-github

  let claude_part = if ($claude_tabs | is-not-empty) {
    $"($CLAUDE_SYMBOL) ($claude_tabs | str join ', ')"
  } else {
    ""
  }

  let github_part = format-github $github_counts
  let github_part = if ($github_part | is-not-empty) {
    $"($GH_SYMBOL) ($github_part)"
  } else {
    ""
  }

  let parts = [$claude_part $github_part] | where { $in | is-not-empty }
  let msg = if ($parts | is-empty) {
    " "  # empty string doesn't clear, need space
  } else {
    $parts | str join "  "
  }

  zellij pipe $"zjstatus::pipe::pipe_corner::($msg)"
}
