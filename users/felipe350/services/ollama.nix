{ ... }: {
  services = {
    ollama = {
      enable = true;
      acceleration = false;
    };
    open-webui.enable = true;
  };
}
