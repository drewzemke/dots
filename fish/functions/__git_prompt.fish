function __git_prompt
    set -l git_dir (git rev-parse --git-dir 2>/dev/null); or return

    set -l branch (git symbolic-ref --short HEAD 2>/dev/null; or git describe --contains --all HEAD 2>/dev/null)
    set -l counts (git rev-list --count --left-right 'HEAD...@{upstream}' 2>/dev/null | string split \t)
    set -q counts[2]; or set counts 0 0
    set -l porcelain (git status --porcelain 2>/dev/null | string sub -l 2)

    set -l out
    test -n "$branch"; and set -a out (set_color -o green)$branch(set_color normal)
    test "$counts[1]" -gt 0; and set -a out (set_color -o magenta)󰛃
    test "$counts[2]" -gt 0; and set -a out (set_color -o magenta)󰛀
    test -e $git_dir/refs/stash; and set -a out (set_color cyan)󰩳
    string match -qr '^([ACDMT][ MT]|[ACMT]D)$' -- $porcelain; and set -a out (set_color green)󰐖
    string match -qr '^[ ACMRT]D$' -- $porcelain; and set -a out (set_color red)󰅗
    string match -qr '[MT]$' -- $porcelain; and set -a out (set_color blue)󰏬
    string match -qr R -- $porcelain; and set -a out (set_color magenta)󰛂
    string match -qr 'AA|DD|U' -- $porcelain; and set -a out (set_color yellow)󰇽
    string match -qr '\?\?' -- $porcelain; and set -a out (set_color white)󰞋

    echo -n (string join ' ' $out)' '(set_color normal)
end
