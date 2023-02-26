{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.x86;

in {
  options.luksab.x86.enable = mkEnableOption "enable desktop config";
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
      # google-chrome-dev
      bitwarden
      spotify
      discord
      zoom-us
      obs
      ryzenadj
      radeontop
      radeon-profile
    ];
  };
}
