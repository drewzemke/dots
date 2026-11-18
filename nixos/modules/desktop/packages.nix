{ pkgs, unstable, own, ... }:

{
  environment.systemPackages = import ../../../packages/desktop.nix { inherit pkgs unstable own; };
}
