# fzf using the current token as the query, replacing it with the selection
# usage: [<source cmd> |] __fzf_insert [fzf args...]
function __fzf_insert
    set -l query (commandline -t)
    set -l result

    # command substitutions don't inherit piped stdin, so read it out first
    if isatty stdin
        set result (fzf --query "$query" $argv | string collect)
    else
        set -l items
        while read -l line
            set -a items $line
        end
        set result (printf '%s\n' $items | fzf --query "$query" $argv | string collect)
    end

    test -n "$result"; and commandline -rt -- (string escape -n -- $result)
    commandline -f repaint
end
