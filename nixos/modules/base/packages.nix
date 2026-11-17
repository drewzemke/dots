{ pkgs, unstable, ... }:

{
  environment.systemPackages = import ../../../packages/base.nix { inherit pkgs unstable; };
}
