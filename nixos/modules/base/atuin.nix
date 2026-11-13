{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.atuin ];

  systemd.user.services.atuin = {
    enable = true;
    description = "atuin daemon";
    serviceConfig = {
      ExecStart = "${pkgs.atuin}/bin/atuin daemon";
      Restart = "always";
      RestartSec = 3;
    };
    wantedBy = [ "default.target" ];
  };
}
