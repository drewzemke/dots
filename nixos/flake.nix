{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable-small";
  };

  outputs = { nixpkgs, unstable, ... }:
    let
      mkHost = name: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          unstable = import unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };
        modules = [ ./hosts/${name}/configuration.nix ];
      };
    in {
      nixosConfigurations.rafael = mkHost "rafael";
    };
}
