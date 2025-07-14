{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      pkgs = (import nixpkgs) {
        system = "x86_64-linux";
        overlays = [
          (final: prev: {
            fish = prev.fish.overrideAttrs (old: {
              doInstallCheck = false;
              checkTarget = "";
              nativeBuildInputs = old.nativeBuildInputs ++ [ final.makeWrapper ];
              src = prev.fetchFromGitHub {
                owner = "OleStrohm";
                repo = "fish-shell";
                rev = "010773c44c1a8828558f61c5784d0166d0bd0bc4";
                hash = "sha256-X/ms5rr2GRjkRtQs8+cPNewIes6QNJ03ne763+PQlRU=";
              };
              patches = [];
              postPatch = "";
              cargoDeps = prev.rustPlatform.fetchCargoVendor {
                inherit (final.fish) src;
                hash = "sha256-HFY3/upUnc1CYhxFq8MOSaN6ZnnC/ScyPiYzdG77Wu4=";
              };
              postInstall = old.postInstall + ''
                wrapProgram $out/bin/fish --add-flag --config_dir=${./.}
              '';
            });
          })
        ];
      };
    in {

    packages.x86_64-linux.default = pkgs.fish;

  };
}
