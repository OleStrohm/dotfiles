# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxPackages_rpi3;
  boot.initrd.availableKernelModules = [
    "usbhid"
    "usb_storage"
    "vc4"
    "pcie_brcmstb" # required for the pcie bus to work
    "reset-raspberrypi" # required for vl805 firmware to load
  ];
  # Audio jack
  boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" "snd_bcm2835.enable_headphones=1" ];

  hardware.enableRedistributableFirmware = true;
  powerManagement.cpuFreqGovernor = "ondemand";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.hostName = "rpi-speaker"; # Define your hostname.

  networking.networkmanager.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    #font = "Lat2-Terminus16";
    keyMap = "uk";
    #useXkbConfig = true; # use xkb.options in tty.
  };
  # Enable sound.
  services.pulseaudio.enable = true;
  services.pulseaudio.systemWide = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.rpi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    librespot
  ];

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHhB2hhIlLOfFR7lORWa/NNiGauahp2n0RtD67vHc5i4 strohm99@gmail.com"
  ];

  networking.firewall.enable = false;

  system.stateVersion = "25.11";
}

