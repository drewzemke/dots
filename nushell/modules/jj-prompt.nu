export def main [] {
  # check if jj is available and we're in a jj repo
  if (which jj | is-empty) {
    return ""
  }

  let jj_root = (do -i { jj root --quiet } | complete)
  if $jj_root.exit_code != 0 {
    return ""
  }

  let jj_log = (jj log --ignore-working-copy --no-graph --color always -r @ -T '
    separate(
      " ",
      bookmarks.join(", "),
      coalesce(
        surround(
          "\"",
          "\"",
          if(
            description.first_line().substr(0, 24).starts_with(description.first_line()),
            description.first_line().substr(0, 24),
            description.first_line().substr(0, 23) ++ "…"
          )
        ),
        label(if(empty, "empty", "author"), "󰞋 ")
      ),
      change_id.shortest(),
      commit_id.shortest(),
      if(conflict, label("conflict", "󰅗 ")),
    )
  ')

  mut symbols = ""

  # check for empty changes
  let empty_changes = (do -i { jj diff } | complete)
  if ($empty_changes.stdout | str trim | is-empty) {
    $symbols = $symbols + " " + $"(ansi green)󱗜"
  }

  # check for fresh commits
  let fresh_commits = (do -i { jj fresh } | complete)
  if ($fresh_commits.stdout | str trim | is-not-empty) {
    $symbols = $symbols + " " + $"(ansi cyan)󰩳"
  }

  # check for outgoing commits
  let outgoing_commits = (do -i { jj out } | complete)
  if ($outgoing_commits.stdout | str trim | is-not-empty) {
    $symbols = $symbols + " " + $"(ansi magenta)󰛃"
  }

  # check for incoming commits
  let incoming_commits = (do -i { jj inc } | complete)
  if ($incoming_commits.stdout | str trim | is-not-empty) {
    $symbols = $symbols + " " + $"(ansi magenta)󰛀"
  }

  let extra_space = if ($symbols | is-not-empty) { " " } else { "" }

  $"(ansi reset)($jj_log)($symbols)($extra_space)(ansi reset)"
}
