{
  description = "Feed the beast - Modded Minecraft launcher";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs = { self, nixpkgs }:
  let
    pname = "ftb-app";
    version = "1.27.5";
    pkgs = (import nixpkgs) { system = "x86_64-linux"; };
    src = system: pkgs.fetchurl {
      url = "https://piston.feed-the-beast.com/app/ftb-app-linux-${version}-x86_64.AppImage";
      sha256 = "sha256-Ja3fE4fELFOOJzFOA52SCGjDHsj/FQwD08eiRTJUD5c=";
    };
  in
  {
    packages.ftb-app.x86_64-linux = pkgs.appimageTools.wrapType2 {
      inherit pname version;
      src = src "x86_64";
    };
    packages.x86_64-linux.default = pkgs.appimageTools.wrapType2 {
      inherit pname version;
      src = src "x86_64";
    };
  };
}
