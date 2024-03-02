# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # TODO: change to be /dev/disk/by-label/boot
  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2624-069E";
      fsType = "vfat";
    };
  # TODO: Change to be /dev/disk/by-label/nixos
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/0908f70b-1036-4b9a-9e07-a218528f315b";
      fsType = "ext4";
    };
  # TODO: Change to be /dev/disk/by-label/home
  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/5a438e95-ddf2-49f4-8cbd-6e0a41868f24";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/ea633716-ce2a-453c-b859-e09f1633f59d"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp15s0f3u2u1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp11s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}