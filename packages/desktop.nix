{ pkgs, unstable, own }:

with pkgs; [
  kanata
] ++ lib.optionals stdenv.isLinux [
  # macs get this as a brew cask
  wezterm
]
