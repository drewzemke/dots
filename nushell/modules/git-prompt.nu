export def main [] {
  # Check if git is available
  if (which git | is-empty) {
    return ""
  }

  # Check if we're in a git repo
  let git_dir = (do -i { git rev-parse --git-dir } | complete)
  if $git_dir.exit_code != 0 {
    return ""
  }

  # Get branch name
  let branch = (do -i { git symbolic-ref --short HEAD } | complete)
  let branch_name = if $branch.exit_code == 0 {
    $branch.stdout | str trim
  } else {
    let desc = (do -i { git describe --contains --all HEAD } | complete)
    if $desc.exit_code == 0 { $desc.stdout | str trim } else { "" }
  }

  # Get ahead/behind counts
  let ahead_behind = (do -i { git rev-list --count --left-right 'HEAD...@{upstream}' } | complete)
  let counts = if $ahead_behind.exit_code == 0 {
    $ahead_behind.stdout | str trim | split row "\t"
  } else {
    ["0", "0"]
  }
  let status_ahead = ($counts | get 0 | into int)
  let status_behind = ($counts | get 1 | into int)

  # Check for stashed changes
  let git_dir_path = $git_dir.stdout | str trim
  let status_stashed = ([$git_dir_path "refs/stash"] | path join | path exists)

  # Get git status
  let porcelain = (git status --porcelain | lines | each { |line| $line | str substring 0..2 })

  let status_added = ($porcelain | any { |s| $s =~ '[ACDMT][ MT]|[ACMT]D' })
  let status_deleted = ($porcelain | any { |s| $s =~ '[ ACMRT]D' })
  let status_modified = ($porcelain | any { |s| $s =~ '[MT]$' })
  let status_renamed = ($porcelain | any { |s| $s =~ 'R' })
  let status_unmerged = ($porcelain | any { |s| $s =~ 'AA|DD|U' })
  let status_untracked = ($porcelain | any { |s| $s =~ '\?\?' })

  mut result = ""

  if ($branch_name | is-not-empty) {
    $result = $result + $"(ansi green_bold)($branch_name)(ansi reset) "
  }

  if $status_ahead > 0 {
    $result = $result + $"(ansi magenta_bold)󰛃 "
  }
  if $status_behind > 0 {
    $result = $result + $"(ansi magenta_bold)󰛀 "
  }
  if $status_stashed {
    $result = $result + $"(ansi cyan)󰩳 "
  }
  if $status_added {
    $result = $result + $"(ansi green)󰐖 "
  }
  if $status_deleted {
    $result = $result + $"(ansi red)󰅗 "
  }
  if $status_modified {
    $result = $result + $"(ansi blue)󰏬 "
  }
  if $status_renamed {
    $result = $result + $"(ansi magenta)󰛂 "
  }
  if $status_unmerged {
    $result = $result + $"(ansi yellow)󰇽 "
  }
  if $status_untracked {
    $result = $result + $"(ansi white)󰞋 "
  }

  $result
}
