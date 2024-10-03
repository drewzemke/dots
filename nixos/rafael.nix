{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

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
    ];
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    docker-compose
    fish
    fzf
    gcc
    gh
    git
    gnumake
    lazydocker
    openssl
    pkg-config
    protobuf
    rustup
    vim
  ];

  # Fish!
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Set your time zone
  time.timeZone = "America/Los_Angeles";

  networking = {
    hostName = "rafael";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 53 80 443 8123 ];
      allowedUDPPorts = [ 53 ];

    };
    interfaces = {
      eno1 = {
        ipv4.addresses = [ {
          address = "192.168.0.101"; 
          prefixLength = 24;
        } ];
      };
    };
    defaultGateway = "192.168.0.1";
    nameservers = [ "8.8.8.8" ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # FIXME
  # services.ddclient = {
  #   enable = true;
  #   configFile = "/etc/ddclient.conf";
  # };

  # nginx
services.nginx = {
  enable = true;
  statusPage = true;
  virtualHosts = {
    "rafael.local" = {
      locations."/pihole/" = {
        proxyPass = "http://localhost:8080/admin/";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;

          proxy_redirect http://localhost:8080/admin/ /pihole/;
          proxy_redirect /admin/ /pihole/;
          sub_filter_once off;
          sub_filter_types text/html;
          sub_filter '/admin/' '/pihole/';
          sub_filter 'src="/admin/' 'src="/pihole/';
          sub_filter 'href="/admin/' 'href="/pihole/';

        '';
      };
      locations."/hass/" = {
        proxyPass = "http://localhost:8123/";
        proxyWebsockets = true;
        extraConfig = ''
          rewrite ^/hass/(.*) /$1 break;

          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_buffering off;

          add_header X-Debug-Message "Proxying to Home Assistant" always;
          error_log /var/log/nginx/hass_debug.log debug;
        '';
      };

      # add trailing slashes
      locations."/pihole" = {
        return = "301 $scheme://$host$request_uri/";
      };
      locations."/hass" = {
        return = "301 $scheme://$host$request_uri/";
      };
    };
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



  # Enable automatic system upgrades
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = "24.05";
}

