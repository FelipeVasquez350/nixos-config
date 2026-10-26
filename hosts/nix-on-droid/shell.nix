{ ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.config =
    { lib, pkgs, ... }:
    {
      home.stateVersion = "24.05";
      home.packages = with pkgs; [
        blesh
        gawk
      ];

      programs.bash = {
        enable = true;
        enableCompletion = true;
        historySize = 5000;
        historyFileSize = 10000;
        historyControl = [
          "ignorespace"
          "erasedups"
        ];
        shellAliases.ls = "ls --color=auto";

        initExtra = lib.mkMerge [
          # Load the editor before plugins, but attach only after all prompt hooks exist.
          (lib.mkOrder 50 ''
            if [[ $TERM != dumb && -t 0 && -t 1 ]]; then
              source ${pkgs.blesh}/share/blesh/ble.sh --attach=none
              bleopt history_share=1
            fi
          '')
          (lib.mkAfter ''
            if [[ $TERM != dumb ]]; then
              bind '"\e[H": beginning-of-line'
              bind '"\e[F": end-of-line'
              bind '"\e[3~": delete-char'
              bind '"\e[1;5D": backward-word'
              bind '"\e[1;5C": forward-word'
            fi

            if declare -F ble-attach >/dev/null; then
              _ble_contrib_fzf_base=${pkgs.fzf}/share/fzf
              ble-import -d integration/fzf-completion
              ble-import -d integration/fzf-key-bindings
              ble-attach
            fi
          '')
        ];
      };

      programs.readline = {
        enable = true;
        includeSystemConfig = false;
        variables = {
          editing-mode = "emacs";
          completion-ignore-case = true;
          show-all-if-ambiguous = true;
          colored-stats = true;
          mark-symlinked-directories = true;
        };
        bindings = {
          "\\e[H" = "beginning-of-line";
          "\\e[F" = "end-of-line";
          "\\e[3~" = "delete-char";
          "\\e[1;5D" = "backward-word";
          "\\e[1;5C" = "forward-word";
        };
      };

      programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = false;
        defaultOptions = [
          "--height=40%"
          "--layout=reverse"
          "--border"
        ];
        changeDirWidgetOptions = [ "--preview 'ls --color=always -- {}'" ];
      };

      programs.zoxide = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = false;
        options = [
          "--cmd"
          "cd"
        ];
      };

      programs.starship = {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = false;
        settings = {
          add_newline = true;
          # A two-line frame like the dotfiles prompt, without requiring a Nerd Font.
          format = lib.concatStrings [
            "[╭─](bright-black)"
            "$os$directory$git_branch$git_status"
            "$status$cmd_duration$nix_shell$python$jobs$time"
            "$line_break"
            "[╰─](bright-black)$character"
          ];
          os = {
            disabled = false;
            format = "[$symbol]($style)";
            style = "bold blue";
            symbols = {
              Android = "Android ";
              Linux = "Linux ";
              NixOS = "Nix ";
            };
          };
          directory = {
            truncation_length = 3;
            truncate_to_repo = false;
            style = "bold blue";
            read_only = " ro";
          };
          git_branch = {
            symbol = "git:";
            style = "bold green";
          };
          git_status.style = "yellow";
          status = {
            disabled = false;
            symbol = "exit:";
            format = "[$symbol$status]($style) ";
          };
          cmd_duration.min_time = 2000;
          nix_shell.symbol = "nix ";
          python = {
            symbol = "py ";
            format = "[$symbol$virtualenv]($style) ";
          };
          jobs.symbol = "jobs:";
          time = {
            disabled = false;
            time_format = "%T";
            format = "[$time]($style) ";
          };
          character = {
            success_symbol = "[❯](bold green)";
            error_symbol = "[❯](bold red)";
          };
        };
      };
    };
}
