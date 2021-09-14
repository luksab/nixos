{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.lukas-bot;
in {
  options.luksab.lukas-bot = {
    enable = mkEnableOption "activate lukas-bot";

    dataDir = mkOption {
      type = types.path;
      default = /var/lib/lukas-bot;
    };

    user = mkOption {
      type = types.str;
      default = "lukas-bot";
      example = "my-own-user";
      description = "User to run lukas-bot as";
    };

    group = mkOption {
      type = types.str;
      default = "lukas-bot";
      example = "my-own-group";
      description = "Group to run lukas-bot as";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.git
      pkgs.nodejs
      pkgs.python
      pkgs.pkg-config
      pkgs.pixman
      pkgs.cairo
      pkgs.pango
      pkgs.haskellPackages.gi-pangocairo
    ];

    systemd.services.lukas-bot = {
      # path = [ ];
      wantedBy = [ "default.target" ];

      preStart = ''
        ${pkgs.git}/bin/git pull
        ${pkgs.nodejs}/bin/npm install
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = toString cfg.dataDir;
        EnvironmentFile = [ "/var/src/secrets/discord.token" ];
        Restart = "on-failure";

        ExecStart = "${pkgs.nodejs}/bin/node index.js";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    users = mkIf (cfg.user == "lukas-bot") {
      groups."${cfg.group}" = { };
      users.lukas-bot = {
        isSystemUser = true;
        group = cfg.group;
        home = toString cfg.dataDir;
        createHome = true;
        description = "lukas-bot system user";
      };
    };

    # networking.firewall =
    #   mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
