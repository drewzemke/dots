{ pkgs, unstable, own, ... }:

{
  environment.systemPackages = import ../../../packages/base.nix { inherit pkgs unstable own; };
}
