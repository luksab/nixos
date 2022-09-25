{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.minecraft-server;
in {
  options.luksab.minecraft-server = {
    enable = mkEnableOption "activate minecraft-server";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/minecraft-server";
      description =
        "The directory where minecraft-server stores its data files.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Open ports in the firewall for minecraft-server.
      '';
    };

    serverFile = mkOption {
      type = types.str;
      default = "fabric-server-launch.jar";
      description = "The name of the jar file to run";
    };

    javaPackage = mkOption {
      type = types.package;
      default = pkgs.jre_headless;
      description = "Java Package to launch server with";
    };

    user = mkOption {
      type = types.str;
      default = "minecraft";
      example = "my-own-user";
      description = "User to run minecraft-server as";
    };

    group = mkOption {
      type = types.str;
      default = "minecraft";
      example = "my-own-group";
      description = "Group to run minecraft-server as";
    };

    port = mkOption {
      type = types.port;
      default = 25565;
      description = ''
        Port being used for minecraft-server
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.minecraft-server = {
      path = [ pkgs.bash pkgs.which cfg.javaPackage ];
      wantedBy = [ "default.target" ];

      # preStart = ''
      #   cp --no-preserve=mode -r ${pkgs.minecraft.src}/static ${cfg.dataDir}/
      #   cp --no-preserve=mode -r ${pkgs.minecraft.src}/webroot ${cfg.dataDir}/
      # '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;

        CPUSchedulingPriority = 20;

        Restart = "always";
        RestartSec = "10";

        WorkingDirectory = "${cfg.dataDir}";
        ExecStart =
          "${cfg.javaPackage}/bin/java -Xms16G -Xmx16G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -jar ${cfg.serverFile}";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    users = mkIf (cfg.user == "minecraft") {
      groups."${cfg.group}" = { };
      users.minecraft = {
        isSystemUser = true;
        group = "${cfg.group}";
        home = "${cfg.dataDir}";
        createHome = true;
        description = "minecraft system user";
      };
    };

    networking.firewall =
      mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
