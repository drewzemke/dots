function notes
    argparse r/rename -- $argv; or return
    cd ~/notes
    set -q _flag_rename; and zellij action rename-tab notes
    $EDITOR ./daily/(date +%Y-%m-%d).md
    cd -
end
