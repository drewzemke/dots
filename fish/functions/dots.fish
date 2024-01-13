#!/usr/bin/env fish
#
# open editor in the .dots directory
function dots
    cd ~/.dots
    $EDITOR .
    cd -
end
