# env vars 
$env.EDITOR = 'hx'
$env.VISUAL = $env.EDITOR
$env.CARGO_HOME = $env.HOME | path join '.cargo'
$env.BUN_INSTALL = $env.HOME | path join '.bun'
$env.DREW_AT_WORK = (hostname) == 'RSS-GT7XF3F95Q'
$env.NUSHELL_ABBREVS = {}

# load path
source path.nu

# load tokens
use ./modules/tokens.nu load-token
load-token OPENROUTER_API_KEY .openrouter
load-token ANTHROPIC_API_KEY   .anthropic

# load functions
use ./functions *

# config
$env.config.show_banner = false
$env.config.completions.algorithm = 'fuzzy'
$env.config.edit_mode = 'helix'
$env.config.cursor_shape.helix_normal = 'block'
$env.config.cursor_shape.helix_select = 'underscore'
$env.config.cursor_shape.helix_insert = 'line'

# helix insert mode inherits ctrl+backspace and ctrl+w but not these emacs
# defaults, so add them back
$env.config.keybindings ++= [
  {
    name: backspace_word
    modifier: alt
    keycode: backspace
    mode: [helix_insert]
    event: { edit: backspaceword }
  }
  {
    name: history_hint_complete
    modifier: control
    keycode: char_f
    mode: [helix_insert]
    event: {
      until: [
        { send: historyhintcomplete }
        { send: menuright }
        { send: right }
      ]
    }
  }
  {
    name: history_hint_word_complete
    modifier: alt
    keycode: char_f
    mode: [helix_insert]
    event: {
      until: [
        { send: historyhintwordcomplete }
        { edit: movewordright }
      ]
    }
  }
]
