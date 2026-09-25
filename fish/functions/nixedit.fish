# edit nix config, redeploy, then commit new config
function nixedit
    $EDITOR ~/nixos/
    sudo nixos-rebuild switch; or return
    git -C ~/dots add nixos/
    git -C ~/dots commit -m "nixos: updated config for `"(hostname)"`"
    git -C ~/dots push
end
