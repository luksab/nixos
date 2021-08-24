{ lib, config, ... }:
with lib;
let cfg = config.luksab.desktop;
in {
  options.luksab.desktop = { enable = mkEnableOption "enable desktop"; };

  config = mkIf cfg.enable {
    luksab = {
      suckless.enable = true;
      common.enable = true;
    };
  };
}
