{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.luksab.overviewer;
  configFile = pkgs.writeText "overviewer-config.py" (''
    # overviewer-config.py managed by NixOS configuration
  '' + cfg.config);
in {
  options.luksab.overviewer = {
    enable = mkEnableOption "activate overviewer";

    time = mkOption {
      type = types.str;
      default = "hourly";
      description = ''
        How often to run overviewer, for example:
              minutely → *-*-* *:*:00
              hourly → *-*-* *:00:00
              daily → *-*-* 00:00:00
              https://www.freedesktop.org/software/systemd/man/systemd.time.html
      '';
    };

    config = mkOption {
      type = types.str;
      default = ''
        worlds["My world"] = "/var/lib/minecraft-server/world"

        renders["normalrender"] = {
            "world": "My world",
            "title": "Normal Render of My World",
        }

        outputdir = "/var/www/overviewer"
      '';
    };

    dataDir = mkOption {
      type = types.path;
      default = /var/www/overviewer;
    };

    # nginx = mkOption {
    #   type = types.bool;
    #   default = false;
    #   description = ''
    #     Configure nginx for overviewer.
    #   '';
    # };

    nginx = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Configure nginx for overviewer.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "minecraft";
      example = "my-own-user";
      description = "User to run overviewer as";
    };

    group = mkOption {
      type = types.str;
      default = "minecraft";
      example = "my-own-group";
      description = "Group to run overviewer as";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.overviewer ];

    systemd.services.overviewer = {
      # path = [ ];
      # wantedBy = [ "default.target" ];

      # preStart = ''
      #   cp --no-preserve=mode -r ${pkgs.minecraft.src}/static ${cfg.dataDir}/
      #   cp --no-preserve=mode -r ${pkgs.minecraft.src}/webroot ${cfg.dataDir}/
      # '';
      path = [ pkgs.overviewer ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "oneshot";

        ExecStart = "${pkgs.overviewer}/bin/overviewer --config=${configFile}";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };
    systemd.timers.overviewer = {
      wantedBy = [ "timers.target" ];
      partOf = [ "overviewer.service" ];
      timerConfig.OnCalendar = "${cfg.time}";
    };

    # users = mkIf (cfg.user == "minecraft") {
    #   groups."${cfg.group}" = { };
    #   users.minecraft = {
    #     isSystemUser = true;
    #     group = "${cfg.group}";
    #     home = "${cfg.dataDir}";
    #     createHome = true;
    #     description = "minecraft system user";
    #   };
    # };

    # networking.firewall =
    #   mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
