{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      overlay = 
          (final: prev: {
            fish-unwrapped = prev.fish.overrideAttrs (old: {
              doInstallCheck = false;
              checkTarget = "";
              src = prev.fetchFromGitHub {
                owner = "OleStrohm";
                repo = "fish-shell";
                rev = "c73099e8c45bc01b52bee6c7eed7fff829640f8f";
                hash = "sha256-nPVZUUU5vljahq576HHxkwMuWeIzzbnkpnYbgNy8ue0=";
              };
              patches = [];
              postPatch = "";
              cargoDeps = prev.rustPlatform.fetchCargoVendor {
                inherit (final.fish-unwrapped) src;
                hash = "sha256-HFY3/upUnc1CYhxFq8MOSaN6ZnnC/ScyPiYzdG77Wu4=";
              };
              postInstall = old.postInstall + ''
              '';
            });
            fish = prev.stdenv.mkDerivation {
              pname = "fish";
              version = "wrapped";

              buildInputs = [ prev.makeWrapper ];
              dontUnpack = true;

              installPhase = ''
                mkdir -p $out/
                cp -r ${final.fish-unwrapped}/* $out/
                chmod -R +rw $out/
                rm $out/bin/fish
                makeWrapper ${final.fish-unwrapped}/bin/fish $out/bin/fish \
                  --add-flag --config_dir=${./.} \
                  --prefix PATH ":" ${prev.lib.makeBinPath (with prev; [ fd zoxide ripgrep eza jujutsu ])}
              '';

              meta = {
                description = "Custom wrapped fish shell";
                mainProgram = "fish";
              };
              passthru = {
                shellPath = "/bin/fish";
              };
            };
          });

      pkgs = (import nixpkgs) {
        system = "x86_64-linux";
        overlays = [ overlay ];
      };
  in
  {
    packages.x86_64-linux.default = pkgs.fish;
    overlays.default = overlay;
  };
}
