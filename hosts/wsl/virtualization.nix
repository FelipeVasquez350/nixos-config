{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ libxslt ];

  virtualisation = {
    docker = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
      };
      allowedBridges = [ "virbr0" ];

      # Enable NSS for libvirt VM hostname resolution
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };
}
