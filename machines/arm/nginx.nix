{ ... }: {
  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
  };
  services.nginx.virtualHosts = {
    "ocp.luksab.de" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/overviewer";
    };
    "luksab.de" = {
      forceSSL = true;
      enableACME = true;
      root = "/var/www/luksab.de";
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
        "/" = {
          extraConfig = ''
            allow 176.198.43.0;
            allow 5.181.49.14;
            allow 91.65.93.7;
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
      listen = [{
        addr = "10.31.69.6";
        port = 443;
        ssl = true;
      }];
      locations."/" = { proxyPass = "http://127.0.0.1:8086"; };
    };
  };
  security.acme.acceptTerms = true;
  security.acme.certs = {
    "ocp.luksab.de".email = "lukassabatschus@gmail.com";
    "luksab.de".email = "lukassabatschus@gmail.com";
    "status.luksab.de".email = "lukassabatschus@gmail.com";
    "private.luksab.de".email = "lukassabatschus@gmail.com";
  };
}
