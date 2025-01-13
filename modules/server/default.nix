{ lib, config, home-manager, ... }:
with lib;
let cfg = config.luksab.server;
in {
  options.luksab.server = { enable = mkEnableOption "enable server"; };

  config = mkIf cfg.enable {
    services.fail2ban.enable = true;

    luksab.common.enable = true;

    luksab.user.emma.home-manager.enable = true;
  };
}
