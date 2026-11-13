{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    darktable
    discord
    firefox
    mongosh
    wezterm
  ];

  environment.variables.BROWSER = "firefox";
}
