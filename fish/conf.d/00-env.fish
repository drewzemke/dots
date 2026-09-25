set -gx EDITOR hx
set -gx VISUAL $EDITOR
set -gx CARGO_HOME ~/.cargo
set -gx BUN_INSTALL ~/.bun
set -gx DREW_AT_WORK (test (hostname) = RSS-GT7XF3F95Q; and echo 1; or echo 0)

fish_add_path -g /usr/local/go/bin /opt/homebrew/bin $BUN_INSTALL/bin $CARGO_HOME/bin ~/.local/bin

load_token OPENROUTER_API_KEY .openrouter
load_token ANTHROPIC_API_KEY .anthropic
