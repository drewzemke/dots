#!/bin/sh
# fresh mac setup: nix, the package profile, then `just bootstrap` for the rest
set -eu
cd "$(dirname "$0")"

if [ "$(uname)" != Darwin ]; then
    echo "macs only. on nixos, add a host to flake.nix and run nixos-rebuild"
    exit 1
fi

if [ ! -f .dotter/local.toml ]; then
    echo "create .dotter/local.toml first, e.g.:"
    echo '  packages = ["base", "mac"]          # add "work" on the work mac'
    exit 1
fi

if grep -q '"work"' .dotter/local.toml; then
    profile=mac-work
else
    profile=mac-personal
fi

if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if ! command -v nix >/dev/null; then
    curl -fsSL https://install.determinate.systems/nix | sh -s -- install
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

nix profile add ".#$profile"
export PATH="$HOME/.nix-profile/bin:$PATH"

just bootstrap
