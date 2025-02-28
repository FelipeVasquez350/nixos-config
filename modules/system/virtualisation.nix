{ config, pkgs, ... }: {
  virtualisation = {
    docker = {
      enable = true;
    };
    # virtualbox = {
    #   host.enable = true;
    #   host.enableExtensionPack = true;
    # };
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm;
      allowedBridges = [ "virbr0" "br0" ];
    };
  };
}
