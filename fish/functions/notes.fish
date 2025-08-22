#!/usr/bin/env fish
#
# open editor in the notes directory
function notes
    # go to notes dir
    cd ~/notes

    # rename current tab if flag was passed
    if test "$argv[1]" = "--rename"; or test "$argv[1]" = "-r"
        zellij action rename-tab "notes"
    end

    # open editor to today's notes
    $EDITOR ./daily/(date +%Y-%m-%d).md

    # back to original dir
    cd -
end
