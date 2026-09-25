function fish_prompt
    set -l segments (string split / (string replace -r "^$HOME" '~' $PWD))
    set -l last $segments[-1]
    set -e segments[-1]

    set -l path
    for seg in $segments
        # keep the dot on hidden dirs so `.config` shortens to `.c`
        set -a path (set_color blue)(string sub -l (string match -q '.*' -- $seg; and echo 2; or echo 1) -- $seg)
    end
    set -a path (set_color -o blue)$last(set_color normal)

    echo -n (string join (set_color blue)/ $path)' '
    echo -n (set_color red)❯(set_color yellow)❯(set_color green)❯(set_color normal)' '
end
