{ config, pkgs, ... }: {

  environment.systemPackages = with pkgs; [ libxslt ];

  virtualisation = {
    docker = { enable = true; };
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;

        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            }).fd
          ];
        };

      };
      allowedBridges = [ "virbr0" "br0" ];

      # Enable NSS for libvirt VM hostname resolution
      onBoot = "ignore";
      onShutdown = "shutdown";
    };
  };

  # Enable NSS for libvirt hostname resolution
  system.nssDatabases.hosts = [ "files" "libvirt" "dns" ];
}
