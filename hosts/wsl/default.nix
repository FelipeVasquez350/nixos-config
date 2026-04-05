{
  inputs,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./virtualization.nix
  ];

  system.stateVersion = "25.11";
  wsl.enable = true;

  programs.zsh.enable = true;
  programs.starship.enable = true;

  users.users.nixos = {
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
      "libvirtd"
    ];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [
        "nixos"
        "@wheel"
      ];
      min-free = 64000000;
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 14d";
    };
  };

  # Enable nix flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.nixos = import ./home.nix;
  };

  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  environment.systemPackages = with pkgs; [
    bat
    carapace
    curl
    fastfetch
    fzf
    htop
    nmap
    nh
    nixd
    nixfmt
    starship
    stow
    vim
    wget
    wl-clipboard
    zoxide
    dig
    direnv
    fd
    git
    jq
  ];
}
