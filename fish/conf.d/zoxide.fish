if not set -q ZOXIDE_VERSION; and type -q zoxide
    ~/.cargo/bin/zoxide init fish | source &
end

if status is-interactive
    abbr -a -- z.. 'z -'
end
