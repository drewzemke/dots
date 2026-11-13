{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    deno
    gcc
    gnumake
    nodejs
    openssl
    openssl.dev
    pkg-config
    pnpm
    protobuf
    rustup
  ];

  # lets cargo builds find openssl
  environment.variables.PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
}
