def find-jj-root [] {
  mut current = (pwd)
  loop {
    if ([$current '.jj'] | path join | path exists) {
      return true
    }
    let parent = ($current | path dirname)
    if $parent == $current {
      return false
    }
    $current = $parent
  }
}

def check-empty [] {
  let changed = (try { jj diff --stat } catch { "" } | lines | length)
  if $changed == 1 {
    $"(ansi green)󱗜"
  } else {
    # stat output includes a summary line at the end
    let count = ($changed - 1)
    $"(ansi yellow)󱗜 ($count)"
  }
}

def check-fresh [] {
  let count = (try { jj log --no-graph -r 'fresh()' -T '"\n"' } catch { "" } | lines | length)
  if $count > 0 {
    $"(ansi cyan)󰩳 ($count)"
  } else {
    ""
  }
}

def check-out [] {
  if (try { jj log --no-graph -r 'out()' --limit 1 } catch { "" } | is-not-empty) {
    $"(ansi magenta)󰛃"
  } else {
    ""
  }
}

def check-inc [] {
  if (try { jj log --no-graph -r 'inc()' --limit 1 } catch { "" } | is-not-empty) {
    $"(ansi magenta)󰛀"
  } else {
    ""
  }
}

export def main [] {
  # check if we're in a jj repo
  if not (find-jj-root) {
    return ""
  }

  # run all checks in parallel
  let symbols = (["empty" "fresh" "out" "inc"]
    | enumerate
    | par-each { |e|
        let result = match $e.item {
          "empty" => (check-empty)
          "fresh" => (check-fresh)
          "out" => (check-out)
          "inc" => (check-inc)
        }
        { index: $e.index, value: $result }
      }
    | sort-by index
    | get value
    | where { |s| $s != "" }
    | str join " ")

  if ($symbols | is-not-empty) {
    $"(ansi reset)($symbols) (ansi reset)"
  } else {
    ""
  }
}
