# env vars 
$env.CARGO_HOME = $env.HOME | path join '.cargo'

$env.EDITOR = 'hx'
$env.VISUAL = $env.EDITOR

$env.NUSHELL_ABBREVS = {}

$env.DREW_AT_WORK = (hostname) == 'RSS-GT7XF3F95Q'

# path
use std/util "path add"
path add '/bin'
path add '/sbin'
path add '/usr/bin'
path add '/usr/sbin'
path add '/usr/local/bin'
path add '/usr/local/go/bin'
path add '/opt/homebrew/bin'
path add ($env.CARGO_HOME | path join 'bin')

# tokens and keys
use ./modules/tokens.nu load-token
load-token OPENROUTER_API_KEY .openrouter
load-token ANTHROPIC_API_KEY   .anthropic

# config
$env.config.show_banner = false
$env.config.completions.algorithm = 'fuzzy'

# theme
use ./themes/dracula.nu
$env.config.color_config = (dracula)

# TODO: move these elsewhere?
def dots [] {
  cd ~/dots
  ^$env.EDITOR .
  cd -
}

def notes [--rename (-r)] {
  cd ~/notes

  if $rename {
    zellij action rename-tab "notes"
  }

  # open editor to today's notes
  ^$env.EDITOR ./daily/(date now | format date "%Y-%m-%d").md

  cd -
}

# TODO: move color stuff elsewhere 
$env.LS_COLORS = (vivid generate dracula)
