#!/usr/bin/env fish
#
# edit nix config, redeploy, then commit new config
function nixedit 
	# edit config
	hx ~/nixos/

	# rebuild
	sudo nixos-rebuild switch

	# if rebuild was successful, commit config
	if test $status -eq 0
		set dir ~/dots

		git -C $dir add nixos/
		git -C $dir commit -m 'nixos: updated config for `'$hostname'`'
		git -C $dir push
	end
end
