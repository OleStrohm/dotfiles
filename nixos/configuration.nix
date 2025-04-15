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

  hardware.fancontrol.enable = true;
  hardware.fancontrol.config = ''
INTERVAL=10
DEVPATH=hwmon0=devices/platform/nct6775.656 hwmon3=devices/pci0000:00/0000:00:18.3
DEVNAME=hwmon0=nct6799 hwmon3=k10temp
FCTEMPS=hwmon0/pwm6=hwmon3/temp1_input hwmon0/pwm3=hwmon3/temp1_input hwmon0/pwm2=hwmon3/temp1_input
FCFANS=hwmon0/pwm6=hwmon0/fan6_input hwmon0/pwm3=hwmon0/fan3_input hwmon0/pwm2=hwmon0/fan5_input+hwmon0/fan2_input
MINTEMP=hwmon0/pwm6=40 hwmon0/pwm3=40 hwmon0/pwm2=40
MAXTEMP=hwmon0/pwm6=80 hwmon0/pwm3=80 hwmon0/pwm2=80
MINSTART=hwmon0/pwm6=66 hwmon0/pwm3=66 hwmon0/pwm2=66
MINSTOP=hwmon0/pwm6=26 hwmon0/pwm3=26 hwmon0/pwm2=26
  '';

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

  networking.hostName = "mars"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    #keyMap = "uk";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.windowManager.awesome.enable = true;
  services.xserver.displayManager.startx.enable = true;
  services.xserver.wacom.enable = true;
  services.getty.autologinUser = "ole";

  # Configure keymap in X11
  services.xserver.xkb.layout = "gb";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ole = {
    isNormalUser = true;
    extraGroups = [ "audio" "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    packages = with pkgs; [
      firefox
      tree
    ];
  };

  services.autorandr.enable = true;
  services.autorandr.matchEdid = true;
  services.autorandr.profiles = {
    mars = {
      fingerprint = {
        "DP-3" = "00ffffffffffff0030aee961000000002b1e0104a53c22783e6665a9544c9d26105054a1080081c0810081809500a9c0b300d1c00101565e00a0a0a0295030203500615d2100001a000000fc00503237682d32300a2020202020000000fd00324c1e5a24000a202020202020000000ff0056393036523830350affffffff01f0020318f14b9005040302011f13140e0f23090f0783010000662156aa51001e30468f33000f282100001eab22a0a050841a30302036000f282100001c7c2e90a0601a1e40302036000f282100001c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006a";
        "HDMI-1" = "00ffffffffffff000469c324fdf700001019010380341d782a2ac5a4564f9e280f5054b7ef00d1c0814081809500b300714f81c08100023a801871382d40582c450009252100001e000000ff0046344c4d54463036333438350a000000fd00324b185311000a202020202020000000fc004153555320564e3234370a202001f6020322714f0102031112130414050e0f1d1e1f10230917078301000065030c0010008c0ad08a20e02d10103e9600fd1e11000018011d007251d01e206e285500fd1e1100001e011d00bc52d01e20b8285540fd1e1100001e8c0ad090204031200c405500fd1e11000018000000000000000000000000000000000000000000e9";
      };
      config = {
        "DP-3" = {
          enable = true;
          primary = true;
          mode = "2560x1440";
          position = "0x0";
          rate = "59.95";
          crtc = 0;
        };
        "HDMI-1" = {
          enable = true;
          mode = "1920x1080";
          position = "2560x0";
          rate = "60.00";
          crtc = 0;
        };
      };
    };
  };

  services.udev.packages = [ udevRules ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    stremio
    delta
    jq
    playerctl
    #ftb-app
  ];

  system.stateVersion = "23.11"; # Do not modify
}

