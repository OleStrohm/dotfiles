{ config, pkgs, lib, ... }:
{
  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];
  boot.kernelPackages = pkgs.linuxPackages_rpi3;
  boot.initrd.availableKernelModules = [ "usbhid" "usb_storage" ];

  boot.supportedFilesystems = lib.mkForce [
    "vfat"
    "xfs"
    "cifs"
    "ntfs"
  ];

  boot.kernelParams = [ "cma=256M" ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  time.timeZone = "Europe/London";

  swapDevices = [{ device = "/swapfile"; size = 1024; }];


  environment.systemPackages = with pkgs; [
    sudo
    nano
    curl
    wget
    bind
    iptables
    tmux
    docker-compose
    usbutils
  ];

  programs.fish.enable = true;
  programs.vim.defaultEditor = true;
  virtualisation.docker.enable = true;

  services.openssh = {
    enable = true;
    #settings.PermitRootLogin = "yes";
  };

  networking.firewall.enable = false;

  hardware = {
    enableRedistributableFirmware = false;
    firmware = [ pkgs.raspberrypiWirelessFirmware ];
  };

  networking = {
    hostName = "rpi-home-assistant";

    interfaces.wlan0 = {
      useDHCP = true;
    };
    interfaces.eth0 = {
      useDHCP = true;
    };
    
    wireless.enable = true;
    wireless.interfaces = [ "wlan0" ];
    wireless.networks."VM1861464_2.4G".psk = "fp3Mqgctgskk";
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
    "net.ipv4.tcp_ecn" = true;
  };

  users.defaultUserShell = pkgs.fish;
  users.mutableUsers = true;
  users.groups = {
    nixos = {
      gid = 1000;
      name = "nixos";
    };
  };
  users.users = {
    nixos = {
      uid = 1000;
      home = "/home/nixos";
      name = "nixos";
      group = "nixos";
      shell = pkgs.fish;
      extraGroups = [ "wheel" "docker" ];
      isNormalUser = true;
    };
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhB2hhIlLOfFR7lORWa/NNiGauahp2n0RtD67vHc5i4 strohm99@gmail.com"
  ];
  system.stateVersion = "20.09";
}
