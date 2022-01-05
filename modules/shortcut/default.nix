{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.shortcut;
in {
  options.luksab.shortcut = {
    enable = mkEnableOption "activate shortcut service";

    user = mkOption {
      type = types.str;
      default = "lukas";
      example = "my-own-user";
      description = "User to run shortcut as";
    };

    group = mkOption {
      type = types.str;
      default = "users";
      example = "my-own-group";
      description = "Group to run shortcut as";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.shortcut = {
      path = [
        pkgs.libusb
        pkgs.nodejs
        pkgs.nodePackages.npm
        pkgs.bash
      ];
      wantedBy = [ "default.target" ];

      environment = {
        LD_LIBRARY_PATH = with pkgs; "${libusb}/lib:${hidapi}/lib";
      };

      preStart = ''
        pwd
        cp --no-preserve=mode,ownership -r ${pkgs.shortcut}/bin/* .
        npm install
        npx tsc
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = toString "/var/shortcut";
        Restart = "on-failure"; 

        ExecStart = "${pkgs.nodejs}/bin/node dist/index.js";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    users = mkIf (cfg.user == "shortcut") {
      groups."${cfg.group}" = { };
      users.shortcut = {
        isSystemUser = true;
        group = cfg.group;
        home = toString cfg.dataDir;
        createHome = true;
        description = "shortcut system user";
      };
    };

    # networking.firewall =
    #   mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
