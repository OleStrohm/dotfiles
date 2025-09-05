{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.vim
  ];

  services.home-assistant = {
    # opt-out from declarative configuration management
    config = null;
    lovelaceConfig = null;
    # configure the path to your config directory
    configDir = "/etc/home-assistant";
    # specify list of components required by your configuration
    extraComponents = [
      "esphome"
      "met"
      "radio_browser"
    ];
  };

  networking.hostName = "nas";

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2Wli9pZkndBaI61xq59zHCsWZF3MSKumOJawYUeHya ole@strohm.no"
  ];

  system.stateVersion = "24.05";
}
