# fzf using the current token as the query, replacing it with the selection
# usage: <source cmd> | __fzf_insert [fzf args...]
function __fzf_insert
    set -l query (commandline -t)
    set -l result (fzf --query "$query" $argv | string collect)
    test -n "$result"; and commandline -rt -- (string escape -n -- $result)
    commandline -f repaint
end
