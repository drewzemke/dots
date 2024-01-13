#!/usr/bin/env fish
#
# open editor in the notes directory
function notes
    cd ~/notes
    $EDITOR .
    cd -
end
