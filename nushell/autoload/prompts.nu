use ../modules/jj-prompt.nu
use ../modules/git-prompt.nu
use ../functions/corner-daemon.nu

def vcs-prompt [] {
  # try jj first (returns empty string if not in a jj repo)
  let jj = (jj-prompt)
  if ($jj | is-not-empty) {
    return $jj
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
  corner-daemon ensure

  let path_segments = (pwd | str replace $env.HOME ~ | split row '/')
  let total = ($path_segments | length)

  let colored_path = ($path_segments
    | enumerate
    | each { |seg| color-segment $seg.item ($seg.index == ($total - 1)) }
    | str join $"(ansi blue)/(ansi reset)")

  [$colored_path " "] | str join
}

# the deco lives in the indicator, not PROMPT_COMMAND: the indicator is the only
# prompt piece reedline re-renders on a mode change, so recoloring it is what
# makes the mode visible. helix reuses the vi indicators, and normal and select
# share vi_normal
def arrows [...colors: string] {
  $colors | each { |c| $"(ansi $c)❯" } | append $"(ansi reset) " | str join
}

$env.PROMPT_INDICATOR = (arrows red yellow green)
$env.PROMPT_INDICATOR_VI_INSERT = (arrows red yellow green)
$env.PROMPT_INDICATOR_VI_NORMAL = (arrows magenta blue cyan)
