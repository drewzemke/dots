{ pkgs, ... }:

{
  systemd.services.kanata = {
    enable = true;
    description = "run kanata";
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kanata}/bin/kanata -c /home/drew/.config/kanata/config.kbd";
      Restart = "always";
      RestartSec = 3;
      User = "root";
      Group = "root";
    };
    wantedBy = [ "multi-user.target" ];
  };

  users.users.drew.extraGroups = [ "uinput" ];
}
