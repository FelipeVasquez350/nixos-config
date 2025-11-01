{ pkgs, ... }: {
  home.packages = with pkgs; [
    blender
    cloudflared
    dig
    direnv
    fnm
    fd
    gcc
    github-desktop
    gh
    glab
    gnumake
    jetbrains.datagrip
    jq
    neovim
    nil
    nixd
    nixfmt-classic
    nixos-anywhere
    pnpm
    python3
    ripgrep
    spice-gtk
    tmux
    OVMF # for UEFI support
    unetbootin # for creating bootable USB drives
    virtiofsd # for shared folders
    virt-manager
    virt-viewer
    wireshark
    vscode
    zed-editor
  ];
}
