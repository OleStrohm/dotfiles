{
  description = "Feed the beast - Modded Minecraft launcher";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    pname = "ftb-app";
    version = "1.25.18";
    pkgs = (import nixpkgs) { system = "x86_64-linux"; };
    src = system: pkgs.fetchurl {
      url = "https://piston.feed-the-beast.com/app/ftb-app-${version}-${system}.AppImage";
      sha256 = "sha256-qqcEovw8SoPzHS3Uz82IxONa/LHr9y9/rt2tIXE/P8g=";
    };
  in
  {
    packages.ftb-app.x86_64-linux = pkgs.appimageTools.wrapType2 {
      inherit pname version;
      src = src "x86_64";
    };
  };
}
