{ unstable, ... }:

{
  systemd.user.services.atuin = {
    enable = true;
    description = "atuin daemon";
    serviceConfig = {
      ExecStart = "${unstable.atuin}/bin/atuin daemon";
      Restart = "always";
      RestartSec = 3;
    };
    wantedBy = [ "default.target" ];
  };
}
