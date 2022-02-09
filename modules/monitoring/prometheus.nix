{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.services.monitoring-server;
in {

  options.luksab.services.monitoring-server = {
    enable = mkEnableOption "monitoring-server setup";

    blackboxTargets = mkOption {
      type = types.listOf types.str;
      default = [ "https://github.com" ];
      example = [ "https://lounge.rocks" ];
      description = "Targets to monitor with the blackbox-exporter";
    };

    blackboxPingTargets = mkOption {
      type = types.listOf types.str;
      default = [ "10.88.88.2" ];
      example = [ "10.88.88.2" ];
      description = "Targets to monitor with the icmp module";
    };

    nodeTargets = mkOption {
      type = types.listOf types.str;
      default = [ "localhost:9100" ];
      example = [ "hostname.wireguard:9100" ];
      description = "Targets to monitor with the node-exporter";
    };
  };

  config = mkIf cfg.enable {

    services.prometheus = {
      enable = true;
      extraFlags = [ "--log.level=debug" "--storage.tsdb.retention.size=10GB" ];
      retentionTime = "10y";
      # environmentFile = /var/src/secrets/prometheus/envfile;

      scrapeConfigs = [
        {
          job_name = "blackbox";
          metrics_path = "/probe";
          params = { module = [ "http_2xx" ]; };
          static_configs = [{ targets = cfg.blackboxTargets; }];

          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement =
                "127.0.0.1:9115"; # The blackbox exporter's real hostname:port.
            }
          ];
        }
        {
          job_name = "icmp";
          metrics_path = "/probe";
          params = { module = [ "icmp" ]; };
          static_configs = [{ targets = cfg.blackboxPingTargets; }];

          relabel_configs = [
            {
              source_labels = [ "__address__" ];
              target_label = "__param_target";
            }
            {
              source_labels = [ "__param_target" ];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement =
                "127.0.0.1:9115"; # The blackbox exporter's real hostname:port.
            }
          ];
        }
        {
          job_name = "node-stats";
          static_configs = [{ targets = cfg.nodeTargets; }];
        }
        {
          job_name = "hass";
          metrics_path = "/api/prometheus";
          bearer_token_file = "/var/src/secrets/home-assistant.token";
          scheme = "https";
          static_configs = [{ targets = [ "ha.luksab.de:443" ]; }];
        }
      ];
    };

    system.activationScripts.setup-home-assistant-token =
      stringAfter [ "users" "groups" ] ''
        echo setting up secrets...
        chmod +xr /var/src/secrets/
        chmod +r /var/src/secrets/home-assistant.token
      '';
  };
}
