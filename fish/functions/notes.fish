function notes
    argparse r/rename -- $argv; or return
    set orig_dir (pwd)
    cd ~/notes
    set -q _flag_rename; and zellij action rename-tab notes
    $EDITOR ./daily/(date +%Y-%m-%d).md
    cd $orig_dir
end
