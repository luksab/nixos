{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.notify-bot;
in
{
  options.luksab.notify-bot = {
    enable = mkEnableOption "activate notify-bot";

    dataDir = mkOption {
      type = types.path;
      default = /var/lib/notify-bot;
    };

    user = mkOption {
      type = types.str;
      default = "notify-bot";
      example = "my-own-user";
      description = "User to run notify-bot as";
    };

    group = mkOption {
      type = types.str;
      default = "notify-bot";
      example = "my-own-group";
      description = "Group to run notify-bot as";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.notify-bot = {
      path = [ ];
      wantedBy = [ "default.target" ];

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = toString cfg.dataDir;
        EnvironmentFile = [ "/var/src/secrets/notify.token" ];
        Restart = "on-failure";

        ExecStart = "${pkgs.discord_notify_go}/bin/discord_notify";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    users = mkIf (cfg.user == "notify-bot") {
      groups."${cfg.group}" = { };
      users.notify-bot = {
        isSystemUser = true;
        group = cfg.group;
        home = toString cfg.dataDir;
        createHome = true;
        description = "notify-bot system user";
      };
    };

    # networking.firewall =
    #   mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
