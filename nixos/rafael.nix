{ config, pkgs, ... }:

{
  # Enable the OpenSSH daemon
  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
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
      # persona mac
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKf35qWcRXme7A6qNvFXZE77gZR77VFkitxXlwPDQAzV drew.zemke@gmail.com" 
    ];
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    fish
    helix
    openssl
    pkg-config
    rustup
    vim
    git
    htop
    docker-compose
  ];

  # Fish!
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Set your time zone
  time.timeZone = "America/Los_Angeles";

  # Firewall configuration
  networking.hostName = "rafael";
  networking.networkmanager.enable = true; 
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ]; # SSH port
  };

  # Enable automatic system upgrades
  system.autoUpgrade.enable = true;

  # This value determines the NixOS release with which your system is to be compatible
  system.stateVersion = "24.05";
}
