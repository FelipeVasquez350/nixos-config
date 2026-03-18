{
  config, # lib,
  pkgs,
  ...
}:

{
  users.groups.cloudflared = { };
  users.users.cloudflared = {
    isSystemUser = true;
    group = "cloudflared";
    home = "/home/cloudflared";
    createHome = true;
    description = "User for running cloudflared";
  };

  #https://github.com/quic-go/quic-go/wiki/UDP-Buffer-Sizes
  boot.kernel.sysctl = {
    # UDP buffer size parameters
    "net.core.rmem_max" = 8388608; # 8MB max receive buffer
    "net.core.wmem_max" = 8388608; # 8MB max send buffer
  };

  environment.systemPackages = with pkgs; [ cloudflared ];

  # https://wiki.nixos.org/wiki/Cloudflared
  # Remember to copy the pem file too in cloudflared home/.cloudflared folder

  # Configure the cloudflared service
  services.cloudflared = {
    enable = true;
    tunnels = {
      "e2e8ca63-13e4-4b50-8518-6d9790b7bcdb" = {
        credentialsFile = config.sops.secrets.cloudflared_credentials_file.path;
        default = "http_status:404";
      };
    };
  };

  sops.secrets.cloudflared_credentials_file = {
    owner = "cloudflared";
    group = "cloudflared";
    mode = "0400";
  };
}
