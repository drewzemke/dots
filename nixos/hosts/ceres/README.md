# standing up ceres

ceres was left on its old channel-based config (`nixos/ceres.nix`, stateVersion 23.11)
while rafael moved to the flake. these are the steps to move it over.

## 1. get the repo onto ceres

```sh
jj git clone <dots remote> ~/dots
```

## 2. copy the hardware config

it holds disk UUIDs and kernel modules for this exact machine, so it can only come from ceres itself.

```sh
cp /etc/nixos/hardware-configuration.nix ~/dots/nixos/hosts/ceres/hardware.nix
cd ~/dots && jj st   # flakes only see files tracked by git
```

## 3. write `hosts/ceres/configuration.nix`

keep it to an import list plus host-specific values:

```nix
{
  imports = [
    ./hardware.nix
    # base (same set rafael imports)
    ../../modules/base/user-drew.nix
    ../../modules/base/timezone.nix
    ../../modules/base/boot-grub.nix
    ../../modules/base/unfree.nix
    ../../modules/base/cli-tools.nix
    ../../modules/base/dev-toolchain.nix
    ../../modules/base/fish.nix
    ../../modules/base/nushell.nix
    ../../modules/base/swap.nix
    ../../modules/base/atuin.nix
    ../../modules/base/notes-sync.nix
    ../../modules/base/nix-maintenance.nix
    # server bits ceres also wants
    ../../modules/server/ssh.nix
    ../../modules/server/docker.nix
    # desktop
    ../../modules/desktop/plasma.nix
    ../../modules/desktop/hyprland.nix
    ../../modules/desktop/nvidia.nix
    ../../modules/desktop/audio.nix
    ../../modules/desktop/fonts.nix
    ../../modules/desktop/gaming.nix
    ../../modules/desktop/kanata.nix
    ../../modules/desktop/removable-drives.nix
    ../../modules/desktop/dual-boot.nix
    ../../modules/desktop/apps.nix
  ];

  networking.hostName = "ceres";
  networking.networkmanager.enable = true;

  # do NOT bump this. it's the release ceres was installed with, not the one it runs
  system.stateVersion = "23.11";
}
```

compare against the old `nixos/ceres.nix` to make sure nothing got dropped, then delete it.

## 4. add ceres to the flake

in `nixos/flake.nix`, next to rafael:

```nix
nixosConfigurations.ceres = mkHost "ceres";
```

## 5. build, then switch

the old system doesn't have flakes enabled yet, so pass the flag for this first build only:

```sh
cd ~/dots/nixos
nixos-rebuild build --flake .#ceres --option experimental-features 'nix-command flakes'
nvd diff /run/current-system result   # skim what's changing
nixos-rebuild switch --flake .#ceres --sudo --option experimental-features 'nix-command flakes'
```

after this, `nix-maintenance.nix` turns flakes on permanently and the normal command works:

```sh
nixos-rebuild switch --flake ~/dots/nixos --sudo
```

## 6. if it breaks

this is a big jump (months-old channel to current stable, plus a shell change). nvidia and
hyprland are the parts most likely to break.

- reboot and pick the previous generation in the grub menu
- or from a tty: `sudo nixos-rebuild switch --rollback`

## 7. things to check after switching

- **ssh**: `ssh.nix` turns password auth off. confirm key login works from another machine
  *before* logging out
- **kanata**: the old service ran `~/.cargo/bin/kanata`. either `cargo install kanata`
  again or switch `kanata.nix` to nixpkgs' `services.kanata`
- **nvidia**: `WLR_NO_HARDWARE_CURSORS` may no longer be needed on newer drivers. drop it
  if cursors look fine without it
- **shell**: login shell is now fish. nushell is still installed for scripts

## 8. clean up the old setup

```sh
sudo nix-channel --list              # remove leftover channels
sudo nix-channel --remove nixos-unstable-small
sudo mv /etc/nixos /etc/nixos.old    # or leave a note pointing to ~/dots/nixos
```

then `jj commit -m "nixos: add ceres to flake"`.
