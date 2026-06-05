# The base configuration for Nix On Droid
{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.packages = with pkgs; [
    # User-facing stuff that you really really want to have
    vim # or some other editor, e.g. nano or neovim
    neovim
    bat
    curl
    wget
    zsh
    git
    gitstatus
    fzf
    zoxide
    fastfetch
    stow
    openssh
    iproute2
    nix-search-cli
    nix-output-monitor
    nvd
    # Some common stuff that people expect to have
    #procps
    #killall
    #diffutils
    which
    coreutils
    findutils
    utillinux
    #tzdata
    hostname
    ncurses
    #man
    #gnugrep
    #gnupg
    #gnused
    #gnutar
    #bzip2
    gzip
    #xz
    #zip
    #unzip

    # Custom nix-on-droid switch script
    (writeShellScriptBin "nod-switch" ''
      set -euo pipefail

      PROFILE=/nix/var/nix/profiles/nix-on-droid
      OLD=$(readlink -f "$PROFILE" 2>/dev/null || true)

      nix-on-droid switch "$@" 2>&1 | ${nix-output-monitor}/bin/nom

      NEW=$(readlink -f "$PROFILE" 2>/dev/null || true)

      if [[ -n "$OLD" && -n "$NEW" && "$OLD" != "$NEW" ]]; then
        ${nvd}/bin/nvd diff "$OLD" "$NEW"
      fi
    '')
  ];

  user.shell = "${pkgs.bashInteractive}/bin/bash";

  # Set up nix for flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Set your time zone
  time.timeZone = "Europe/Rome";

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  # Read the changelog before changing this value
  system.stateVersion = "24.05";
}
