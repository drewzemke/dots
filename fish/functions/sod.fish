#!/usr/bin/env fish
#
# start of day
function sod 
	function log -a color bold message
		echo (set_color (if $bold; echo "-o"; end) $color)$message
		set_color normal
	end

	log magenta true "Start of Day"

	log green false "Pulling notes..."
	git -C ~/notes pull

	log cyan false "Pulling dots..."
	git -C ~/dots pull

	log cyan false "Deploying dots..."
	fish -c 'cd ~/dots ; exec dotter'

	log magenta true "Have a nice day!"
end
