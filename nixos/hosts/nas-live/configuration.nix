# headless live usb for poking at the nas. boots, gets dhcp, publishes nas.local
{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/base/fish.nix
    ../../modules/base/packages.nix
    ../../modules/base/unfree.nix
    ../../modules/base/user-drew.nix

    ../../modules/server/avahi.nix
    ../../modules/server/ssh.nix
  ];

  networking.hostName = "nas";

  # nic name unknown on this hardware
  services.avahi.allowInterfaces = lib.mkForce null;

  # installer image defaults are looser than ssh.nix
  services.openssh.settings.PermitRootLogin = lib.mkForce "no";

  # no password exists on a live image
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    hdparm
    lshw
    nvme-cli
    pciutils
    smartmontools
    usbutils
  ];
}
