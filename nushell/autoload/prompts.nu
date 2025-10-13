use ../modules/jj-prompt.nu 
use ../modules/git-prompt.nu 

def vcs-prompt [] {
  # check if jj is available and we're in a jj repo
  if (which jj | is-not-empty) {
    let jj_root = (do -i { jj root --quiet } | complete)
    if $jj_root.exit_code == 0 {
      return (jj-prompt)
    }
  }

  # otherwise fall back to git
  git-prompt
}

$env.PROMPT_COMMAND_RIGHT = { ||
  mut result = ""

  # Show last command status if it failed
  let last_exit = $env.LAST_EXIT_CODE
  if $last_exit != 0 {
    $result = $result + $"(ansi red)✘ ($last_exit)(ansi reset)"
  }

  # Add VCS prompt
  let vcs = (vcs-prompt)
  if ($vcs | is-not-empty) {
    if ($result | is-not-empty) {
      $result = $result + " "
    }
    $result = $result + $vcs
  }

  $result
}

def shorten-segment [] {
  let seg = $in
  if ($seg | str starts-with '.') {
    $seg | str substring 0..1
  } else {
    $seg | str substring 0..0
  }
}

def color-segment [seg: string, is_last: bool] {
  let segment_text = if $is_last {
    $seg
  } else {
    $seg | shorten-segment
  }

  if $is_last {
    # last segment: bold and bright blue
    $"(ansi blue_bold)($segment_text)(ansi reset)"
  } else {
    # other segments: normal blue
    $"(ansi blue)($segment_text)(ansi reset)"
  }
}

$env.PROMPT_COMMAND = { ||
  let path_segments = (pwd | str replace $env.HOME ~ | split row '/')
  let total = ($path_segments | length)

  let colored_path = ($path_segments
    | enumerate
    | each { |seg| color-segment $seg.item ($seg.index == ($total - 1)) }
    | str join $"(ansi blue)/(ansi reset)")

  # add deco after path
  [$colored_path " " (ansi red)❯ (ansi yellow)❯ (ansi green)❯ " "] | str join
}

$env.PROMPT_INDICATOR = ""
