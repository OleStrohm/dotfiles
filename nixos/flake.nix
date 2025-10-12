{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fish-overlay = {
      url = "path:../fish/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "path:../nvim/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #ftb-flake = {
    #  url = "path:./ftb";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = { nixpkgs, home-manager, neovim, lanzaboote, fish-overlay/*, ftb-flake*/, ... }@inputs:
    let
      system = "x86_64-linux";
      overlays = [
        fish-overlay.overlays.default
        neovim.overlays.default
        #(final: prev: { ftb-app = ftb-flake.packages.ftb-app.x86_64-linux; })
      ];
    in {
    nixosConfigurations.mars = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs = { inherit overlays; }; }
        lanzaboote.nixosModules.lanzaboote
        #neovim.nixosModules.default
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
