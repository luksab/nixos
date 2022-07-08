{ ... }: {
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
  };
  services.nginx.virtualHosts = {
    "ocp.luksab.de" = {
      enableSSL = true;
      enableACME = true;
      locations."/" = { proxyPass = "http://127.0.0.1:7878"; };
    };
    "luksab.de" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/luksab.de";
      locations = { "/" = { extraConfig = "access_log off;"; }; };
    };
    "sabatschus.de" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/luksab.de";
      locations = { "/" = { extraConfig = "access_log off;"; }; };
    };
    "lukas.sabatschus.de" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/luksab.de";
      locations = { "/" = { extraConfig = "access_log off;"; }; };
    };
    "flares.science" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/flares.science";
      locations = { "/" = { extraConfig = "access_log off;"; }; };
      locations = { "/starburst/" = { basicAuthFile = "/var/www/users"; }; };
    };
    "docs.flares.science" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/docs.flares.science";
      locations = { "/" = { extraConfig = "access_log off;"; }; };
    };
    "turn.luksab.de" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/turn.luksab.de";
      locations = { "/" = { extraConfig = "access_log off;"; }; };
    };
    "private.luksab.de" = {
      addSSL = true;
      enableACME = true;
      root = "/var/www/private";
      locations = {
        "/hooks/" = {
          proxyPass = "http://127.0.0.1:9000";
          # extraConfig = ''
          #   proxy_set_header   Host $host;
          # '';
        };
        "/" = {
          extraConfig = ''
            allow 176.198.43.0;
            allow 5.181.49.14;
            allow 91.65.93.7;
            allow 88.152.15.128;
            allow 158.101.219.227;
            # netcup-x86-runner-1.lounge.rocks
            allow 89.58.12.139;
            allow 2a03:4000:60:ece::;
            deny all;'';
        };
      };
    };
    "status.luksab.de" = {
      forceSSL = true;
      enableACME = true;
      listen = [{
        addr = "10.31.69.6";
        port = 443;
        ssl = true;
      }];
      locations."/" = { proxyPass = "http://127.0.0.1:9005"; };
    };
    # InfluxDB
    "influx.luksab.de" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = { proxyPass = "http://127.0.0.1:8086"; };
    };
  };
  security.acme.acceptTerms = true;
  security.acme.certs = {
    "ocp.luksab.de".email = "lukassabatschus@gmail.com";
    "luksab.de".email = "lukassabatschus@gmail.com";
    "status.luksab.de".email = "lukassabatschus@gmail.com";
    "private.luksab.de".email = "lukassabatschus@gmail.com";
    "lukas.sabatschus.de".email = "lukassabatschus@gmail.com";
    "flares.science".email = "lukassabatschus@gmail.com";
    "docs.flares.science".email = "lukassabatschus@gmail.com";
    "sabatschus.de".email = "lukassabatschus@gmail.com";
  };
}
