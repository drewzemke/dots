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
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  # Enable Docker
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # Create a user account
  users.users.drew = {
    isNormalUser = true;
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

  # Basic system packages
  environment.systemPackages = with pkgs; [
    unstable.deno
    docker-compose
    fish
    fzf
    gcc
    gh
    git
    gnumake
    jq
    lazydocker
    openssl
    openssl.dev
    pkg-config
    pnpm
    protobuf
    rustup
    vim
  ];

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

  # Fish!
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

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
      "*/2 * * * *  drew  /home/drew/dev/librero/scripts/deploy.fish >> /home/drew/dev/librero/scripts/deploy.log 2>&1"
      "0 * * * *  drew  /home/drew/dev/rust-baby-server/scripts/deploy.fish >> /home/drew/dev/rust-baby-server/scripts/deploy.log 2>&1"
      "*/5 * * * *  drew  cd /home/drew/notes && /home/drew/notes/scripts/update.sh"
    ];
  };

  # # ssl
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "drew.zemke@gmail.com";
  # };

  # security.acme.certs."rafael.local" = {
  #   webroot = "/var/lib/acme/acme-challenge";
  #   extraDomainNames = [ "rafael.local" ];
  #   postRun = "systemctl reload nginx.service";
  # };

  # nginx
  # services.nginx = {
  #   enable = true;
  #   virtualHosts."rafael.local" = {
  #     # forceSSL = true;
  #     # sslCertificate = "/var/lib/acme/rafael.local/fullchain.pem";
  #     # sslCertificateKey = "/var/lib/acme/rafael.local/key.pem";

  #     locations."/baby" = {
  #       proxyPass = "http://localhost:3000/";
  #       extraConfig = ''
  #           rewrite ^/baby$ / break;
  #           rewrite ^/baby(.*)$ $1 break;
  #         '';     
  #     };
  #   };

  #   # recommendedTlsSettings = true;
  #   recommendedProxySettings = true;
  # };

  # Enable automatic system upgrades
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = "24.05";
}

