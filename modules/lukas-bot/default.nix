{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.emma-bot;
in {
  options.luksab.emma-bot = {
    enable = mkEnableOption "activate emma-bot";

    dataDir = mkOption {
      type = types.path;
      default = /var/lib/emma-bot;
    };

    user = mkOption {
      type = types.str;
      default = "emma-bot";
      example = "my-own-user";
      description = "User to run emma-bot as";
    };

    group = mkOption {
      type = types.str;
      default = "emma-bot";
      example = "my-own-group";
      description = "Group to run emma-bot as";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.emma-bot = {
      path = [
        pkgs.git
        pkgs.nodejs-16_x
        pkgs.python
        pkgs.pkg-config
        pkgs.pixman
        pkgs.libuuid
        pkgs.gcc
        pkgs.cairo
        pkgs.pango
        pkgs.haskellPackages.gi-pangocairo
        pkgs.ffmpeg
      ];
      wantedBy = [ "default.target" ];

      preStart = ''
        ${pkgs.git}/bin/git pull
        ${pkgs.nodejs-16_x}/bin/npm install
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = toString cfg.dataDir;
        EnvironmentFile = [ "/var/src/secrets/discord.token" ];
        Restart = "on-failure";

        ExecStart = "${pkgs.nodejs-16_x}/bin/node index.js";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    users = mkIf (cfg.user == "emma-bot") {
      groups."${cfg.group}" = { };
      users.emma-bot = {
        isSystemUser = true;
        group = cfg.group;
        home = toString cfg.dataDir;
        createHome = true;
        description = "emma-bot system user";
      };
    };

    # networking.firewall =
    #   mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
