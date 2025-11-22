# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, ... }:

{
  imports =
    [ ./services ./system ./users/v/nixos.nix ./hardware-configuration.nix ];

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # <--- Often the missing piece for Steam
  }; # Bootloader.

  boot.kernelParams = [
    "preempt=full" # Soft RT latency
    "threadirqs" # Soft RT latency
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.edk2-uefi-shell.enable = true;
  boot.loader.systemd-boot.windows = {
    "11" = {
      title = "Windows 11";
      efiDeviceHandle = "HD1c65535a1";
    };
  };
  boot.loader.efi.canTouchEfiVariables = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.v = import ./users/v/home.nix;
  };

  networking = {
    hostName = "Akatosh";
    nameservers = [ "1.1.1.1" "1.1.0.1" ];
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };
  services.resolved.enable = true;

  services.fwupd.enable = true; # For Framework firmware updates
}
