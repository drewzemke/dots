#!/usr/bin/env fish
#
# open a file in the adjacent hx pane
zellij action move-focus right
zellij action write 27 # send escape-key
zellij action write-chars ":open $argv"
zellij action write 13 # send enter-key  
