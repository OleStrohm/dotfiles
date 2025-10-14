{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... }@inputs:
    let
      system = "aarch64-linux";
    in {
    nixosConfigurations.rpi-speaker = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs = { }; }
        ./configuration.nix
      ];
    };
  };
}
