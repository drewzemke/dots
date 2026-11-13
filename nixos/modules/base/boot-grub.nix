{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true; # needed for rafael's mobo
    device = "nodev";
  };
}
