function fish_right_prompt
    set -l last_status $status
    set -l parts

    test $last_status -ne 0; and set -a parts (set_color red)"✘ $last_status"(set_color normal)

    set -l vcs (__jj_prompt)
    test -z "$vcs"; and set vcs (__git_prompt)
    test -n "$vcs"; and set -a parts $vcs

    echo -n (string join ' ' $parts)
end
