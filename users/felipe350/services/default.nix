{ # config, pkgs,
... }: {
  imports = [ ./cloudflared.nix ./dops.nix ./ollama.nix ];
}
