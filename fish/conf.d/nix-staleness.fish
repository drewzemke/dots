status is-interactive; or return
test -e /etc/NIXOS; or return

__nix_staleness_check ~/dots/flake.lock 30
