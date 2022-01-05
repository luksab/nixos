{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.matrix;
in {
  options.luksab.matrix = {
    enable = mkEnableOption "activate matrix";
    host = mkOption {
      type = types.str;
      default = "luksab.de";
      description = ''
        fqdn for Matrix homeserver.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.coturn = rec {
      enable = true;
      no-cli = true;
      no-tcp-relay = true;
      min-port = 49000;
      max-port = 50000;
      use-auth-secret = true;
      static-auth-secret = "ae4nz89opse45vt7nz8ionmu89opasce45tzegahuo"; # very secure password :)
      realm = "turn.luksab.de";
      cert = "${config.security.acme.certs.${realm}.directory}/full.pem";
      pkey = "${config.security.acme.certs.${realm}.directory}/key.pem";
      extraConfig = ''
        # for debugging
        verbose
        # ban private IP ranges
        no-multicast-peers
        denied-peer-ip=0.0.0.0-0.255.255.255
        denied-peer-ip=10.0.0.0-10.255.255.255
        denied-peer-ip=100.64.0.0-100.127.255.255
        denied-peer-ip=127.0.0.0-127.255.255.255
        denied-peer-ip=169.254.0.0-169.254.255.255
        denied-peer-ip=172.16.0.0-172.31.255.255
        denied-peer-ip=192.0.0.0-192.0.0.255
        denied-peer-ip=192.0.2.0-192.0.2.255
        denied-peer-ip=192.88.99.0-192.88.99.255
        denied-peer-ip=192.168.0.0-192.168.255.255
        denied-peer-ip=198.18.0.0-198.19.255.255
        denied-peer-ip=198.51.100.0-198.51.100.255
        denied-peer-ip=203.0.113.0-203.0.113.255
        denied-peer-ip=240.0.0.0-255.255.255.255
        denied-peer-ip=::1
        denied-peer-ip=64:ff9b::-64:ff9b::ffff:ffff
        denied-peer-ip=::ffff:0.0.0.0-::ffff:255.255.255.255
        denied-peer-ip=100::-100::ffff:ffff:ffff:ffff
        denied-peer-ip=2001::-2001:1ff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=2002::-2002:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fc00::-fdff:ffff:ffff:ffff:ffff:ffff:ffff:ffff
        denied-peer-ip=fe80::-febf:ffff:ffff:ffff:ffff:ffff:ffff:ffff
      '';
    };
    # open the firewall
    networking.firewall = {
      interfaces.enp0s3 = let
        range = with config.services.coturn; [{
          from = min-port;
          to = max-port;
        }];
      in {
        allowedUDPPortRanges = range;
        allowedUDPPorts = [ 3478 ];
        allowedTCPPortRanges = range;
        allowedTCPPorts = [ 3478 ];
      };
    };
    # get a certificate
    # security.acme.certs.${config.services.coturn.realm} = {
    #   postRun = "systemctl restart coturn.service";
    #   group = "turnserver";
    # };
    # configure synapse to point users to coturn
    services.matrix-synapse = with config.services.coturn; {
      turn_uris = [
        "turn:${realm}:3478?transport=udp"
        "turn:${realm}:3478?transport=tcp"
      ];
      turn_shared_secret = static-auth-secret;
      turn_user_lifetime = "1h";

      enable = true;
      server_name = "${cfg.host}";
      enable_registration = false;
      listeners = [{
        port = 8008;
        bind_address = "::1";
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [{
          names = [ "client" "federation" ];
          compress = false;
        }];
      }];
    };

    services.postgresql.enable = true;
    services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
      CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
      CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
        TEMPLATE template0
        LC_COLLATE = "C"
        LC_CTYPE = "C";
    '';

    services.nginx = {
      recommendedGzipSettings = true;
      recommendedProxySettings = true;

      virtualHosts = {
        "${cfg.host}" = {
          enableACME = true;
          forceSSL = true;

          locations."= /.well-known/matrix/server".extraConfig = let
            # use 443 instead of the default 8448 port to unite
            # the client-server and server-server port for simplicity
            server = { "m.server" = "${cfg.host}:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';

          locations."= /.well-known/matrix/client".extraConfig = let
            client = {
              "m.homeserver" = { "base_url" = "https://${cfg.host}"; };
              "m.identity_server" = { "base_url" = "https://vector.im"; };
            };
            # ACAO required to allow element-web on any URL to request this json file
          in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';

          # forward all Matrix API calls to the synapse Matrix homeserver
          locations."/_matrix" = {
            proxyPass = "http://[::1]:8008"; # without a trailing /
          };
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 80 443 ];

    luksab.nginx.enable = true;
  };
}
