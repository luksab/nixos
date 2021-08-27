{ lib, config, ... }:
with lib;
let cfg = config.luksab.server;
in {
  options.luksab.server = { enable = mkEnableOption "enable server"; };

  config = mkIf cfg.enable {
    imports = [ ../../users/lukas.nix ../../users/root.nix ];

    services.fail2ban.enable = true;

    luksab = {
      common.enable = true;
    };
  };
}