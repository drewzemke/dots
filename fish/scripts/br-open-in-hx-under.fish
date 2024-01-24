#!/usr/bin/env fish
#
# if this is run from a floating pane, this opens a file in hx in the main pane underneath
zellij action toggle-floating-panes
zellij action write 27 # send escape-key
zellij action write-chars ":open $argv"
zellij action write 13 # send enter-key
zellij action toggle-floating-panes
zellij action close-pane  
