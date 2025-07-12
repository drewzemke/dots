function fish_right_prompt 
    set -l cmd_status $status
    if test $cmd_status -ne 0
        echo -n (set_color red)"✘ $cmd_status"(set_color normal)
    end

    fish_vcs_prompt $argv
end
