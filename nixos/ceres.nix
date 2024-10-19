{ config, lib, pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  # boot loader
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.supportedFilesystems = [ "ntfs" ];

  networking.hostName = "ceres"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "America/Los_Angeles";

  # x11
  services.xserver = {
    enable = true; 
    displayManager.lightdm.enable = true;
    windowManager.leftwm.enable = true;
  };
  services.displayManager.autoLogin = {
    enable = true;
    user = "drew";
  };

  # kanata
  systemd.services.kanata = {
    enable = true;
    description = "run kanata";
    unitConfig = {
      type = "simple";
    };
    serviceConfig = {
      ExecStart = "/home/drew/.cargo/bin/kanata -c /home/drew/.config/kanata/config.kbd";
      Restart = "always";
      RestartSec = 3;
      User = "root";
      Group = "root";
    };
    wantedBy = [ "multi-user.target" ];
  };

  # sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.pulseaudio = true;

  # user
  users.users.drew = {
    uid = 1000;
    isNormalUser = true;
    extraGroups = [ "wheel" "uinput" "docker" ]; # Enable ‘sudo’ for the user.
    description = "Drew Zemke";
  };

  # packages
  environment.systemPackages = with pkgs; [
    atuin
    darktable
    discord
    feh
    firefox
    fish
    fzf
    gcc
    gh
    git
    gnumake
    just
    lazydocker
    openssl
    pavucontrol
    picom
    pkg-config
    polybar
    rofi
    rustup
    vim
    wezterm
    wget
    xclip
  ];

  environment.variables = {
    PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig";
  };

  programs.steam.enable = true; 
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
    "steam"
    "steam-original"
    "steam-run"
    "nvidia-x11"
    "nvidia-settings"
    "nvidia-persistenced"
  ]; 
  
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # docker
  virtualisation.docker.enable = true;


  # enable reading attached drives
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # enable the OpenSSH daemon.
  services.openssh.enable = true;

  # font things
  fonts.packages = with pkgs; [
    nerdfonts 
  ];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # nvidia
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # don't change this or whatever
  system.stateVersion = "23.11";

}

