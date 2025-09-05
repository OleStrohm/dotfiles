# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
  udevRules = pkgs.callPackage ./udev/udev.nix { inherit pkgs; };
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  networking.firewall.enable = false;

  # For stremio
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
  ];

#  hardware.fancontrol.enable = true;
#  hardware.fancontrol.config = ''
#INTERVAL=10
#DEVPATH=hwmon0=devices/platform/nct6775.656 hwmon3=devices/pci0000:00/0000:00:18.3
#DEVNAME=hwmon0=nct6799 hwmon3=k10temp
#FCTEMPS=hwmon0/pwm6=hwmon3/temp1_input hwmon0/pwm3=hwmon3/temp1_input hwmon0/pwm2=hwmon3/temp1_input
#FCFANS=hwmon0/pwm6=hwmon0/fan6_input hwmon0/pwm3=hwmon0/fan3_input hwmon0/pwm2=hwmon0/fan5_input+hwmon0/fan2_input
#MINTEMP=hwmon0/pwm6=40 hwmon0/pwm3=40 hwmon0/pwm2=40
#MAXTEMP=hwmon0/pwm6=80 hwmon0/pwm3=80 hwmon0/pwm2=80
#MINSTART=hwmon0/pwm6=66 hwmon0/pwm3=66 hwmon0/pwm2=66
#MINSTOP=hwmon0/pwm6=26 hwmon0/pwm3=26 hwmon0/pwm2=26
#  '';

  nixpkgs.config.allowUnfree = true;
  #nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #  "steam"
  #];
  programs.steam.enable = true;
  programs.noisetorch.enable = true;

  programs.fish.enable = true;
  programs.direnv.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.htop.enable = true;

  # Default root password to nothing
  users.users.root.initialHashedPassword = ""; # TODO: This can probably be removed
  users.users.root.shell = pkgs.fish;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.efi.canTouchEfiVariables = false; # TODO: Set to true
  boot.loader.systemd-boot.extraEntries = {
    "arch.conf" = ''
title arch
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initramfs-linux.img
options root="UUID=78f86361-7c27-4d84-9ffc-155f3fa30477" rw
'';
    "lts.conf" = ''
title Arch LTS
linux /vmlinuz-linux-lts
initrd /amd-ucode.img
initrd /initramfs-linux-lts.img
options root="UUID=78f86361-7c27-4d84-9ffc-155f3fa30477" rw
'';
    "memtest86.conf" = ''
title Memtest86+
efi /memtest86+/memtest.efi
'';
  };

  networking.hostName = "deimos";
  networking.networkmanager.enable = true;

  #time.timeZone = "Europe/Oslo";
  services.automatic-timezoned.enable = true;
  services.geoclue2.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    useXkbConfig = true;
  };

  services.xserver.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.wacom.enable = true;
  services.xserver.xkb.options = "caps:super";
  services.libinput.touchpad.naturalScrolling = true;

  services.getty.autologinUser = "ole";

  services.xserver.xkb.layout = "gb";

  services.pipewire.enable = true;

  users.users.ole = {
    isNormalUser = true;
    extraGroups = [ "audio" "wheel" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      firefox
      tree
    ];
  };

  services.udev.packages = [ udevRules ];

    #fonts.packages = with pkgs; [
    #  (nerdfonts.override { fonts = [ "FiraCode" ]; })
    #  fira-code
    #];

  environment.systemPackages = with pkgs; [
    alacritty
    neovim
    fish
    git
    dmenu
    pavucontrol
    discord
    vim
    wget
    zoxide
    clang
    ripgrep
    kitty
    wofi
    aseprite
    spotify
    xclip
    fd
    maim
    lm_sensors
    eza
    btop
    dust
    kicad
    zip
    freecad
    obsidian
    probe-rs
    godot_4
    inkscape
    arc-icon-theme
    acpi
    brightnessctl
    stremio
    jujutsu
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  system.stateVersion = "23.11"; # Do not modify
}

