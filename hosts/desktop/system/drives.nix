{ ... }: {
  # Mount for additional drives
  fileSystems = {
    # NVMe drive 1 (WD_BLACK SN770 2TB) - /dev/nvme0n1p1
    "/run/media/v/secondary" = {
      device = "/dev/disk/by-label/secondary";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    # SATA drive 1 (ST1000DM010 931GB - /dev/sda)
    "/run/media/v/LinuxVolume" = {
      device = "/dev/disk/by-uuid/07d6bc72-2a44-403a-974e-52db30653f34";
      fsType = "ext4";
      options = [ "defaults" "nofail" ];
    };

    # SATA drive 2 (ST4000DM004 3.6TB - /dev/sdd)
    "/run/media/v/StorageVolume" = {
      device = "/dev/disk/by-uuid/f9f8d296-7784-45b8-9322-46b4e6610ef2";
      fsType = "btrfs";
      options = [ "defaults" "nofail" ];
    };
  };

  # Ensure mount directories exist with proper permissions
  systemd.tmpfiles.rules = [
    "d /run/media/v/secondary 0755 root root"
    "d /run/media/v/LinuxVolume 0755 root root"
    "d /run/media/v/StorageVolume 0755 root root"
  ];
}
