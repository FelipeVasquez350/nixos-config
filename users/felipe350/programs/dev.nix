{ pkgs, ... }: {
  home.packages = with pkgs; [
    aseprite
    # ansible
    blender
    # cdrtools
    cloudflared
    dbeaver-bin
    dig
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
    virtiofsd # for shared folders
    virt-manager
    virt-viewer
    vscode
    zed-editor
    jq
  ];
}
