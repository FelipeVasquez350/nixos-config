{ config, pkgs, ... }:
{

  # Enable the Tailscale service daemon
  services.tailscale = {
    enable = true;
    extraUpFlags = [ "--ssh" ];

  };

  # Make the CLI tool available to your user environment
  environment.systemPackages = [
    pkgs.tailscale
  ];

  # Configure the firewall for Tailscale
  networking.firewall = {
    # Always trust the tailscale interface to allow internal traffic
    trustedInterfaces = [ "tailscale0" ];

    # Allow the Tailscale UDP port through for peer-to-peer connections
    allowedUDPPorts = [ config.services.tailscale.port ];
  };
}
