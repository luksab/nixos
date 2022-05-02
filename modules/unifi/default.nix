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

    adminPort = mkOption {
      type = types.str;
      default = "8443";
      example = "8443";
      description = "Port that gets bind to localhost";
    };
  };

  config = let adminPort = "${cfg.adminPort}";
  in mkIf cfg.enable {

    services.unifi = {
      enable = true;
      unifiPackage = pkgs.unifi;
    };

    # Open firewall ports
    networking.firewall = {
      allowedUDPPorts = [ 3478 ];
      allowedTCPPorts = [ 8080 8883 ];
    };

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
          locations."/" = {
            proxyPass = "https://127.0.0.1:${toString adminPort}";
          };
        };
      };
    };
  };
}
