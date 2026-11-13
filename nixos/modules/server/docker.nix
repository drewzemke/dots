{ pkgs, ... }:

{
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_29;
    autoPrune.enable = true;
  };

  users.users.drew.extraGroups = [ "docker" ];
  environment.systemPackages = [ pkgs.lazydocker ];
}
