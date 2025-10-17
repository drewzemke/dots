# env vars 
$env.EDITOR = 'hx'
$env.VISUAL = $env.EDITOR
$env.CARGO_HOME = $env.HOME | path join '.cargo'
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
