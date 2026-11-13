{
  imports = [
    ./hardware.nix

    ../../modules/base/atuin.nix
    ../../modules/base/boot-grub.nix
    ../../modules/base/cli-tools.nix
    ../../modules/base/dev-toolchain.nix
    ../../modules/base/fish.nix
    ../../modules/base/nix-maintenance.nix
    ../../modules/base/notes-sync.nix
    ../../modules/base/nushell.nix
    ../../modules/base/swap.nix
    ../../modules/base/timezone.nix
    ../../modules/base/unfree.nix
    ../../modules/base/user-drew.nix

    ../../modules/server/avahi.nix
    ../../modules/server/docker-compose-services.nix
    ../../modules/server/docker.nix
    ../../modules/server/fail2ban.nix
    ../../modules/server/k3s.nix
    ../../modules/server/nix-ld.nix
    ../../modules/server/ssh.nix
  ];

  networking = {
    hostName = "rafael";
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.1.101";
        prefixLength = 24;
      }];
    };
    defaultGateway = "192.168.1.254";
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22    # ssh
        53    # dns
        80    # http
        443   # https
        6443  # k3s API server
        8080  # pihole web interface
        8123  # hass
      ];
      allowedUDPPorts = [
        53    # dns
        67
        8472  # k3s
      ];
      extraCommands = ''
        iptables -I nixos-fw -s 45.87.249.170 -j DROP
      '';
    };
    # pihole first; fallback so rafael can still resolve if the container is down
    nameservers = [ "127.0.0.1" "8.8.8.8" ];
  };

  # do NOT bump this. it's the release rafael was installed with, not the one it runs
  system.stateVersion = "24.05";
}
