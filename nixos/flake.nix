{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #ftb-flake = {
    #  url = "path:./ftb";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { self, nixpkgs, home-manager, neovim-nightly-overlay/*, ftb-flake*/ }@inputs:
    let
      system = "x86_64-linux";
      overlays = [
        neovim-nightly-overlay.overlays.default
        #(final: prev: { ftb-app = ftb-flake.packages.ftb-app.x86_64-linux; })
      ];
    in {
    nixosConfigurations.mars = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs = { inherit overlays; }; }
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ole = import ./home.nix;
        }
      ];
    };
  };
}
