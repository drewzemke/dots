def check-empty [] {
  if (do -i { jj diff } | is-empty) {
    $"(ansi green)󱗜"
  } else {
    $"(ansi yellow)󱗜"
  }
}

def check-fresh [] {
  if (do -i { jj log --no-graph -r 'fresh()' --limit 1 } | is-not-empty) {
    $"(ansi cyan)󰩳"
  } else {
    ""
  }
}

def check-out [] {
  if (do -i { jj log --no-graph -r 'out()' --limit 1 } | is-not-empty) {
    $"(ansi magenta)󰛃"
  } else {
    ""
  }
}

def check-inc [] {
  if (do -i { jj log --no-graph -r 'inc()' --limit 1 } | is-not-empty) {
    $"(ansi magenta)󰛀"
  } else {
    ""
  }
}

export def main [] {
  # check if we're in a jj repo
  if (do -i { jj root --quiet } | complete | get exit_code) != 0 {
    return ""
  }

  # run all checks in parallel
  let symbols = (["empty" "fresh" "out" "inc"]
    | par-each { |check|
        match $check {
          "empty" => (check-empty)
          "fresh" => (check-fresh)
          "out" => (check-out)
          "inc" => (check-inc)
        }
      }
    | where { |s| $s != "" }
    | str join " ")

  if ($symbols | is-not-empty) {
    $"(ansi reset)($symbols) (ansi reset)"
  } else {
    ""
  }
}
