# edit nix config, redeploy, then commit new config
export def main [] {
  let dir = $"($env.HOME)/dots"

  # edit config
  ^$env.EDITOR ~/nixos/

  # rebuild
  let result = do { sudo nixos-rebuild switch } | complete

  # if rebuild was successful, commit config
  if $result.exit_code == 0 {
    git -C $dir add nixos/
    git -C $dir commit -m $"nixos: updated config for `(hostname)`"
    git -C $dir push
  }
}
