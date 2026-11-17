{ pkgs, ... }:

{
  # c toolchain for cargo builds; mac gets these from xcode clt
  environment.systemPackages = with pkgs; [
    gcc
    gnumake
    openssl
    openssl.dev
    pkg-config
  ];

  # lets cargo builds find openssl
  environment.variables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}
