{ pkgs, unstable, ... }:

{
  environment.systemPackages = import ../../../packages/desktop.nix { inherit pkgs unstable; };
}
