{ config, pkgs, lib, ... }:
with lib;
let cfg = config.luksab.service.unifi;
in {

  options.luksab.service.unifi = {

    enable = mkEnableOption "UniFi Controller";

    acmeMail = mkOption {
      type = types.str;
      default = "lukassabatschus@gmail.com";
      example = "lukassabatschus@gmail.com";
      description = "Mail to use for ACME";
    };

    domain = mkOption {
      type = types.str;
      default = "unifi.luksab.de";
      example = "unifi.luksab.de";
      description = "(Sub-) domain for unifi.";
    };
  };

  config = let adminPort = "${cfg.adminPort}";
  in mkIf cfg.enable {

    services.unifi = {
      enable = true;
      unifiPackage = pkgs.unifi;
      openFirewall = false;
    };

    # Open firewall ports
    # networking.firewall = {
    #   allowedUDPPorts = [ 3478 ];
    #   allowedTCPPorts = [ 8080 8883 ];
    # };

    security.acme = {
      acceptTerms = true;
      certs = { ${cfg.domain}.email = "${cfg.acmeMail}"; };
    };

    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      virtualHosts = {
        # UniFi Controller
        "${cfg.domain}" = {
          enableACME = true;
          forceSSL = true;
          extraConfig = ''
            client_max_body_size 0;
          '';
          locations = {
            "/" = { proxyPass = "https://127.0.0.1:8443"; };
            "~(/wss|/manage|/login|/status|/templates|/src|/services|/directives|/api)" =
              {
                proxyPass = "https://127.0.0.1:8443";
                extraConfig = ''
                  proxy_set_header Authorization "";
                  proxy_pass_request_headers on;
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-Host $server_name;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Proto $scheme;
                  proxy_set_header X-Forwarded-Ssl on;
                  proxy_http_version 1.1;
                  proxy_buffering off;
                  proxy_redirect off;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection "Upgrade";
                '';
              };
          };
        };
      };
    };
  };
}
