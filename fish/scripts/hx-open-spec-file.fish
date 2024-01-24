#!/usr/bin/env fish
#
# if passed a .ts, .tsx, .js, or .jsx file, creates a .spec.{ext} file and 
# then opens it in helix 

# load the current file name into the clipboard:
# - paste from the filename buffer (`"%p`)
# - yank to the system clipboard (` y`) 
# - undo the paste (`u`)
zellij action write-chars '"%p yu'

# wait for the clipboard to catch up
sleep 0.2

# change the file extension (from .ts to .spec.ts, for example)
# TODO: if there's already `.spec` in the name, remove it
set new_filename (pbpaste | sed -r 's/\.([^\.]*)$/.spec.\1/g')

# open the new file
zellij action write-chars ":open $new_filename"
zellij action write 13 # enter key  

