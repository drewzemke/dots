{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs = { nixpkgs, nixpkgs-darwin, unstable, ... }:
    let
      importPkgs = src: system: import src {
        inherit system;
        config.allowUnfree = true;
      };

      mkHost = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          unstable = importPkgs unstable "x86_64-linux";
        };
        modules = [ ./nixos/hosts/${name}/configuration.nix ];
      };

      # layers are lists in ./packages, combined into one profile per machine role
      mkEnv = pkgs: unstable: name: layers: pkgs.buildEnv {
        inherit name;
        paths = builtins.concatMap
          (layer: import ./packages/${layer}.nix { inherit pkgs unstable; })
          layers;
      };

      darwin = rec {
        system = "aarch64-darwin";
        pkgs = importPkgs nixpkgs-darwin system;
        unstablePkgs = importPkgs unstable system;
        env = mkEnv pkgs unstablePkgs;
      };
    in {
      nixosConfigurations.rafael = mkHost "rafael";

      packages.${darwin.system} = {
        mac-personal = darwin.env "mac-personal" [ "base" "desktop" ];
        mac-work = darwin.env "mac-work" [ "base" "desktop" "work" ];
      };
    };
}
