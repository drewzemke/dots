$env.PROMPT_COMMAND_RIGHT = { || "" }

def shorten-segment [] {
  let seg = $in
  if ($seg | str starts-with '.') {
    $seg | str substring 0..1
  } else {
    $seg | str substring 0..0
  }
}

$env.PROMPT_COMMAND = { ||
  pwd
    | str replace $env.HOME ~ 
    | split row '/'
    # shorten all but the last segment
    | reverse
    | enumerate
    | each {|segment| if $segment.index == 0 { $segment.item } else { $segment.item | shorten-segment } }
    | reverse
    | str join '/'
    # add deco after path
    | append [" " (ansi cyan)❯ (ansi blue)❯ (ansi magenta)❯ " "]
}

$env.PROMPT_INDICATOR = ""
