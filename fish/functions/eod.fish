#!/usr/bin/env fish
#
# end of day
function eod
	function log -a color bold message
		echo (set_color (if $bold; echo "-o"; end) $color)$message
		set_color normal
	end

	log magenta true "End of Day"

	echo 
	log green false "Pushing notes..."
	git -C ~/notes add .
	git -C ~/notes commit -m 'update '(date +"%a %b %d, %Y %H:%M")
	git -C ~/notes push

	echo
	log cyan false "Pushing dots..."
	if test (git -C ~/dots status --porcelain | wc -l) -gt 0
		log red true "Error: uncommited changes in dots. Please review and commit."
		return 1
	else
		git -C ~/dots push
	end

	echo
	log magenta true "Mischief managed."
end
