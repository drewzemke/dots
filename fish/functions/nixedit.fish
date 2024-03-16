#!/usr/bin/env fish
#
# edit nix config and redeploy
function nixedit 
	sudoedit /etc/nixos/configuration.nix
	sudo nixos-rebuild switch
end
