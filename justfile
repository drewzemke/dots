# machine role comes from the dotter packages in .dotter/local.toml
work := `grep -q '"work"' .dotter/local.toml 2>/dev/null && echo true || echo false`
profile := if work == "true" { "mac-work" } else { "mac-personal" }

sync:
    jj fetch
    jj evolve
    dotter deploy
    {{ if os() == "macos" { "nix profile upgrade " + profile } else { "" } }}

# first-time setup after bootstrap.sh has installed nix and the profile
bootstrap:
    #!/usr/bin/env bash
    set -euo pipefail
    dotter deploy
    if [ "{{ os() }}" = macos ]; then
        brew bundle --file=Brewfile
        if {{ work }}; then brew bundle --file=Brewfile.work; fi
    fi
    just steel-plugins
    just cargo-packages

# nixos only
rebuild:
    nixos-rebuild switch --flake . --sudo

steel_plugins := "https://github.com/drewzemke/helix-file-watcher"

# install steel plugins with forge, then check their steel matches steelix's
steel-plugins:
    #!/usr/bin/env bash
    set -euo pipefail
    for url in {{steel_plugins}}; do
        forge pkg install --git "$url" --force
    done

    # dylib plugins must be built against the same steel as hx, or helix breaks
    rev=$(jq -r '.nodes.unstable.locked.rev' flake.lock)
    src=$(nix build --no-link --print-out-paths "github:NixOS/nixpkgs/$rev#steelix.unwrapped.src")
    steelix_steel=$(grep -A2 'name = "steel-core"' "$src/Cargo.lock" | grep -o '#[0-9a-f]*' | tr -d '#')
    status=0
    for lock in "${STEEL_HOME:-$HOME/.local/share/steel}"/cogs/*/Cargo.lock; do
        plugin_steel=$(grep -A2 'name = "steel-core"' "$lock" | grep -o '#[0-9a-f]*' | tr -d '#')
        if [ "$plugin_steel" != "$steelix_steel" ]; then
            echo "steel mismatch in $(basename "$(dirname "$lock")"): plugin $plugin_steel, steelix $steelix_steel"
            status=1
        fi
    done
    exit $status

# crates not (yet) in nix
cargo-packages:
    cargo install climer tongo
