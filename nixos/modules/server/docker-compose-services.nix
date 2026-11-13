{ pkgs, ... }:

{
  environment.systemPackages = [ pkgs.docker-compose ];

  # brings up everything in ~/services on boot
  systemd.services.docker-compose = {
    description = "Docker Compose Services";
    requires = [ "docker.service" ];
    after = [ "docker.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = "yes";
      WorkingDirectory = "/home/drew/services";
      ExecStart = "${pkgs.docker-compose}/bin/docker-compose up -d";
      ExecStop = "${pkgs.docker-compose}/bin/docker-compose down";
    };
  };
}
