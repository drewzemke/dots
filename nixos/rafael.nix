{ config, lib, pkgs, ... }:

let 
  unstable = import <nixos-unstable-small> {
    config = config.nixpkgs.config;
  };
in {
  imports = [ /etc/nixos/hardware-configuration.nix ];

  # grub as bootloader
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true; # needs this to work with my mobo 
    device = "nodev";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
      MaxAuthTries = 3;
      LoginGraceTime = 20;
      AuthenticationMethods = "publickey";
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "1h";
    bantime-increment = {
      enable = true;
      maxtime = "48h";
    };
  };

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Create a user account
  users.users.drew = {
    isNormalUser = true;
    linger = true;
    extraGroups = [ "wheel" "docker" ]; 
    openssh.authorizedKeys.keys = [
      # personal mac
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKf35qWcRXme7A6qNvFXZE77gZR77VFkitxXlwPDQAzV drew.zemke@gmail.com" 
      # work mac
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC91W695pYx41GogjRXOk5L4Fnmj76Uzb3jwWBhnV49G dnzemke@ucdavis.edu" 
      # nixos desktop
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPurjFbj4NHI6ThdBS3A0ndE08+o9NuQYVtVUS6cSWjM drew.zemke@gmail.com"
    ];
  };

  # atuin daemon
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

  # rafael-agent telegram bot
  systemd.user.services.rafael-agent = {
    enable = true;
    description = "rafael-agent";
    serviceConfig = {
      ExecStart = "${pkgs.deno}/bin/deno task start";
      WorkingDirectory = "/home/drew/dev/rafael-agent";
      Restart = "always";
      RestartSec = 3;
      EnvironmentFile = "/home/drew/dev/rafael-agent/.env";
    };
    environment.PATH = lib.mkForce "/run/current-system/sw/bin:/home/drew/.local/bin:/run/wrappers/bin";
    wantedBy = [ "default.target" ];
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    atuin
    deno
    docker-compose
    fish
    fzf
    gcc
    gh
    git
    gnumake
    jjui
    jq
    jujutsu
    lazydocker
    unstable.nushell
    openssl
    openssl.dev
    pkg-config
    pnpm
    protobuf
    rustup
    vim
  ];

  programs.nix-ld.enable = true;

  # FIXME: this doesn't work the way it's supposed to. 
  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
  # stuck with OpenSSL beefing a cargo install? try this:
  # 
  # # change directory to the install of openssl
  # /nix/store/*openssl*/lib/pkgconfig
  #
  # # export to the pkg-config path
  # export PKG_CONFIG_PATH=(pwd)
  #
  # then try installing again

  # shell
  users.defaultUserShell = pkgs.nushell;

  # Set your time zone
  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "rafael";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        22    # ssh 
        53    # dns
        80    # http
        443   # https 
        8080  # pihole web interface
        8123  # hass
      ];
      allowedUDPPorts = [ 53 ];
      extraCommands = ''
        iptables -I nixos-fw -s 45.87.249.170 -j DROP
      '';

    };
    interfaces = {
      eno1 = {
        ipv4.addresses = [ {
          address = "192.168.0.101"; 
          prefixLength = 24;
        } ];
        ipv6.addresses = [ {
          address = "2601:204:F100:9C50:BF13:4159:F902:6C43";
          prefixLength = 64;
        } ];
      };
    };
    defaultGateway = "192.168.0.1";
    nameservers = [ "8.8.8.8" ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    allowInterfaces = [ "eno1" ];
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # docker-compose
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

  # cron
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * *  drew  /home/drew/dev/librero/scripts/deploy.fish >> /home/drew/dev/librero/scripts/deploy.log 2>&1"
      "*/5 * * * *  drew  cd /home/drew/notes && /home/drew/notes/scripts/update.sh"
    ];
  };

  # passwordless nixos-rebuild
  security.sudo.extraRules = [{
    users = [ "drew" ];
    commands = [{
      command = "/run/current-system/sw/bin/nixos-rebuild";
      options = [ "NOPASSWD" ];
    }];
  }];

  # Enable automatic system upgrades
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = "24.05";
}


