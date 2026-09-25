function __jj_prompt
    # one call so the working copy is snapshotted and the repo loaded only once.
    # each commit prints its tags: w<n> (working copy, n changed files), f, o, i
    set -l tags (jj log --no-graph -r '@ | fresh() | out() | inc()' -T '
        if(current_working_copy, "w" ++ self.diff().files().len() ++ " ")
        ++ if(self.contained_in("fresh()"), "f ")
        ++ if(self.contained_in("out()"), "o ")
        ++ if(self.contained_in("inc()"), "i ")
    ' 2>/dev/null); or return
    set tags (string split -n ' ' -- $tags)

    set -l symbols
    set -l changed (string replace -rf '^w' '' -- $tags)
    if test "$changed" -gt 0
        set -a symbols (set_color yellow)"󱗜 $changed"
    else
        set -a symbols (set_color green)󱗜
    end

    set -l n (count (string match f -- $tags))
    test $n -gt 0; and set -a symbols (set_color cyan)"󰩳 $n"
    set n (count (string match o -- $tags))
    test $n -gt 0; and set -a symbols (set_color magenta)"󰛃 $n"
    set n (count (string match i -- $tags))
    test $n -gt 0; and set -a symbols (set_color magenta)"󰛀 $n"

    # the space must come before the color reset or wezterm squeezes the wide icons
    echo -n (string join ' ' $symbols)' '(set_color normal)
end
