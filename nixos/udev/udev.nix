{ pkgs }: pkgs.stdenv.mkDerivation rec {
  name = "probe_rs_udev_rules-${version}";
  version = "1.0";

  src = ./.;

  nativeBuildINputs = [];
  buildInputs = [];

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    cp 69-probe-rs.rules $out/lib/udev/rules.d/
  '';
}
