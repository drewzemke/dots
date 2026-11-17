{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    darktable
    discord
    firefox
    mongosh
  ];

  environment.variables.BROWSER = "firefox";
}
