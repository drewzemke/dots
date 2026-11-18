sync:
    jj fetch
    jj evolve
    dotter

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
