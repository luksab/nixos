{ config, pkgs, lib, ... }:
with lib;
let cfg = config.luksab.services.thelounge;
in {
  options.luksab.services.thelounge = {
    enable = mkEnableOption "The Lounge IRC client and bouncer";
  };

  config = mkIf cfg.enable {

    luksab.nginx.enable = true;

    services.nginx = {
      virtualHosts."ocp.luksab.de" = {
        enableACME = true;
        forceSSL = true;
        root = "/var/www/ocp.luksab.de";
        locations."^~ /irc/".extraConfig = ''
            proxy_pass http://127.0.0.1:9090/;
            proxy_http_version 1.1;
            proxy_set_header Connection "upgrade";
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;

            # by default nginx times out connections in one minute
            proxy_read_timeout 1d;
        '';
      };
    };

    services.thelounge = {
      enable = true;
      port = 9090; # Default port
      private = true;
      extraConfig = {
        host = "127.0.0.1";
        reverseProxy = true;

        theme = "morning";
      };
    };
  };
}
