{ pkgs, lib, ... }: {
  systemd.services = {
    dops-setup = {
      description = "Setup Better Docker PS";
      requires = [ "docker.service" ];
      after = [ "docker.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      # Specify the path to the packages needed for the script
      path = [ pkgs.curl ];
      environment = {
        "PATH" = lib.mkForce
          "${pkgs.curl}/bin:${pkgs.coreutils}/bin:/run/current-system/sw/bin";
      };

      script = ''
        # Install Better Docker PS
        curl -L "https://github.com/Mikescher/better-docker-ps/releases/latest/download/dops_linux-amd64-static" -o "/usr/bin/dops" && chmod +x "/usr/bin/dops"
      '';
    };
  };

}
