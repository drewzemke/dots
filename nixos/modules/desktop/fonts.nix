{ pkgs, ... }:

{
  fonts.packages = with pkgs.nerd-fonts; [
    jetbrains-mono
    sauce-code-pro
  ];
}
