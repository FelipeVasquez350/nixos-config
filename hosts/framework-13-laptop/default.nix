# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-79a38375-cef1-4667-b999-789430d3f8c6".device =
    "/dev/disk/by-uuid/79a38375-cef1-4667-b999-789430d3f8c6";
  networking = {
    hostName = "framework-13";
    networkmanager.enable = true;
  };

  services.fwupd.enable = true; # For Framework firmware updates
}
