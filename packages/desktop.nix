{ pkgs, unstable, own }:

with pkgs; lib.optionals stdenv.isLinux [
  # macs get kanata from cargo (input monitoring permission needs a stable path)
  # and wezterm as a brew cask
  kanata
  wezterm
]
