{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";

    # my own projects
    army = {
      url = "github:drewzemke/army-of-daemons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    party = {
      url = "github:drewzemke/post-push-party";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixpkgs-darwin, unstable, army, party, ... }:
    let
      importPkgs = src: system: import src {
        inherit system;
        config.allowUnfree = true;
      };

      own = system: {
        army = army.packages.${system}.default;
        party = party.packages.${system}.default;
      };

      mkHost = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          unstable = importPkgs unstable "x86_64-linux";
          own = own "x86_64-linux";
        };
        modules = [ ./nixos/hosts/${name}/configuration.nix ];
      };

      # layers are lists in ./packages, combined into one profile per machine role
      mkEnv = pkgs: unstable: own: name: layers: pkgs.buildEnv {
        inherit name;
        paths = builtins.concatMap
          (layer: import ./packages/${layer}.nix { inherit pkgs unstable own; })
          layers;
      };

      darwin = rec {
        system = "aarch64-darwin";
        pkgs = importPkgs nixpkgs-darwin system;
        unstablePkgs = importPkgs unstable system;
        env = mkEnv pkgs unstablePkgs (own system);
      };
    in {
      nixosConfigurations.rafael = mkHost "rafael";

      packages.${darwin.system} = {
        mac-personal = darwin.env "mac-personal" [ "base" "desktop" ];
        mac-work = darwin.env "mac-work" [ "base" "desktop" "work" ];
      };
    };
}
