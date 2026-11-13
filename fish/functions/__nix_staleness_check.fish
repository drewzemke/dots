function __nix_staleness_check -a lock max_days
    test -f $lock; or return 0
    command -q jq; or return 0

    # oldest input, so a fresh unstable can't hide a stale stable
    set -l oldest (jq '[.nodes[].locked.lastModified? // empty] | min' $lock 2>/dev/null)
    string match -qr '^\d+$' -- "$oldest"; or return 0

    set -l days (math --scale=0 "($(date +%s) - $oldest) / 86400")
    if test $days -gt $max_days
        echo "nix inputs are $days days old, time for `nix flake update`"
    end
    return 0
end
