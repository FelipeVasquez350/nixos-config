{ pkgs, ... }: {
  home.packages = with pkgs; [
    aseprite
    # ansible
    blender
    # cdrtools
    cloudflared
    dbeaver-bin
    dig
    direnv
    # flux
    fnm
    gcc
    gnumake
    github-desktop
    gh
    glab
    # kubectl
    # kubernetes-helm
    # helm-ls
    # minikube
    nil
    nixd
    nixfmt-classic
    nixos-anywhere
    neovim
    pnpm
    python3
    # terraform
    # terraform-ls
    spice-gtk
    tmux
    OVMF # for UEFI support
    unetbootin # for creating bootable USB drives
    virtiofsd # for shared folders
    virt-manager
    virt-viewer
    vscode
    zed-editor-fhs
    jq
  ];
}
