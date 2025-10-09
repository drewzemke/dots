$env.PROMPT_COMMAND_RIGHT = { || "" }

$env.PROMPT_COMMAND = { ||
  pwd
    | str replace $env.HOME ~ 
    | split row '/'
    | reverse
    | enumerate
    | each {|slug| if $slug.index == 0 { $slug.item } else { $slug.item | str substring 0..0 } }
    | reverse
    | str join '/'
  # add deco after path
    | append " "
    | append (ansi cyan)❯
    | append (ansi blue)❯
    | append (ansi magenta)❯
    | append " "
}

$env.PROMPT_INDICATOR = ""
