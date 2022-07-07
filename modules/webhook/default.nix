{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.webhook;
in
{
  options.luksab.webhook = {
    enable = mkEnableOption "activate webhook";

    dataDir = mkOption {
      type = types.path;
      default = /var/lib/webhook;
    };

    repo = mkOption {
      type = types.str;
      default = "git@git.luksab.de:lukas/webhooks.git";
    };

    user = mkOption {
      type = types.str;
      default = "webhook";
      example = "my-own-user";
      description = "User to run webhook as";
    };

    group = mkOption {
      type = types.str;
      default = "webhook";
      example = "my-own-group";
      description = "Group to run webhook as";
    };
  };

  config = mkIf cfg.enable {

    systemd.services.webhook = {
      path = [
        pkgs.git
        pkgs.openssh
        pkgs.nix
        pkgs.webhook
      ];
      wantedBy = [ "default.target" ];

      preStart = ''
        echo $DEPLOY_KEY | sed 's/|/\n/g' > id_rsa;
        chmod 600 id_rsa;
        eval `ssh-agent`; ssh-add id_rsa;
        mkdir -p ~/.ssh
        ssh-keyscan -t rsa git.luksab.de >> ~/.ssh/known_hosts
        ${pkgs.git}/bin/git clone ${cfg.repo} hooks || (
          cd hooks
          ${pkgs.git}/bin/git fetch --all
          ${pkgs.git}/bin/git reset --hard origin/master
          cd ..
        )
        cp hooks/start_webhhok.sh start_webhhok.sh
        chmod +x start_webhhok.sh
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = toString cfg.dataDir;
        EnvironmentFile = [ "/var/src/secrets/deployKey" ];
        Restart = "on-failure";

        ExecStart = "/var/lib/webhook/start_webhhok.sh";
      };

      environment = {
        LC_ALL = "en_US.UTF-8";
        LANG = "en_US.UTF-8";
      };
    };

    users = mkIf (cfg.user == "webhook") {
      groups."${cfg.group}" = { };
      users.webhook = {
        isSystemUser = true;
        group = cfg.group;
        home = toString cfg.dataDir;
        createHome = true;
        description = "webhook system user";
      };
    };

    # networking.firewall =
    #   mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
