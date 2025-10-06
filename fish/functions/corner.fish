#!/usr/bin/env fish
#
# put a message in the top corner of the zjstatus bar
function corner
	if test (count $argv) -gt 0
		set input $argv[1]
	else if not isatty stdin
		read input
	end
	if not test -z "$input"
		zellij pipe "zjstatus::pipe::pipe_corner::$input"
	end
end
