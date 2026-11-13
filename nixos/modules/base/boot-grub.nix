{
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true; # needed for rafael's mobo
    device = "nodev";
    configurationLimit = 10; # keeps /boot from filling with old kernels
  };
}
