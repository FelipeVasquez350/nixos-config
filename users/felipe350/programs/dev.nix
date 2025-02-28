{ pkgs, ... }: {
  home.packages = with pkgs; [
    ansible
    cdrtools
    gcc
    github-desktop
    gh
    neovim
    terraform
    spice-gtk
    OVMF  # for UEFI support
    virtiofsd  # for shared folders
    virt-manager
    virt-viewer
    vscode
    zed-editor
    jq
  ];
}
