# determinate only hooks brew fish (/opt/homebrew/etc/fish), not nix fish, so load nix here
if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
end

set -gx XDG_CONFIG_HOME ~/.config
set -gx EDITOR hx
set -gx VISUAL $EDITOR
set -gx CARGO_HOME ~/.cargo
set -gx BUN_INSTALL ~/.bun
set -gx DREW_AT_WORK (test (hostname) = RSS-GT7XF3F95Q; and echo 1; or echo 0)

fish_add_path -g /usr/local/go/bin /opt/homebrew/bin $BUN_INSTALL/bin $CARGO_HOME/bin ~/.local/bin ~/dots/scripts
# separate call so nix wins over brew/cargo copies (profile on macs, system on nixos)
fish_add_path -gm ~/.nix-profile/bin /run/wrappers/bin /run/current-system/sw/bin

load_token OPENROUTER_API_KEY .openrouter
load_token ANTHROPIC_API_KEY .anthropic
