#!/usr/bin/env fish
#
# notify using zellij and zjstatus
function notify
	set input $argv[1]
	if not test -z $input
		zellij pipe "zjstatus::notify::$input"
	end
end
