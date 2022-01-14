{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.wg_hosts;
in {
  options.luksab.wg_hosts = {
    enable = mkEnableOption "wireguard available hosts";
  };

  config = mkIf cfg.enable {
    networking.extraHosts =
    ''
        10.31.69.1 pfcloud.luksab.de
        10.31.69.3 pfhome.luksab.de
        10.31.69.6 status.luksab.de arm
        10.31.69.101 desktop
        10.31.69.107 laptop
    '';
  };
}
