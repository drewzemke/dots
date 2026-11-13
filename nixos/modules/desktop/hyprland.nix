{ pkgs, ... }:

{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    grim
    hyprpaper
    mako
    slurp
    waybar
    wl-clipboard
    wofi
  ];

  # electron/chromium apps use wayland
  environment.variables.NIXOS_OZONE_WL = "1";
}
