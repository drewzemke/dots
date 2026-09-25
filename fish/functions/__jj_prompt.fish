function __jj_prompt
    jj root --ignore-working-copy &>/dev/null; or return

    set -l symbols

    # stat output includes a summary line at the end
    set -l changed (math (jj diff --stat 2>/dev/null | count) - 1)
    if test $changed -le 0
        set -a symbols (set_color green)󱗜
    else
        set -a symbols (set_color yellow)"󱗜 $changed"
    end

    for check in cyan:fresh magenta:out magenta:inc
        set -l color (string split : $check)
        set -l n (jj log --no-graph -r "$color[2]()" -T '"x\n"' 2>/dev/null | count)
        test $n -gt 0; and set -a symbols (set_color $color[1])(__jj_prompt_icon $color[2])" $n"
    end

    echo -n (string join ' ' $symbols)(set_color normal)
end

function __jj_prompt_icon
    switch $argv[1]
        case fresh
            echo 󰩳
        case out
            echo 󰛃
        case inc
            echo 󰛀
    end
end
