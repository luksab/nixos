{ lib, config, pkgs, ... }:
with lib;

let cfg = config.luksab.xrdp;

in {
  options.luksab.xrdp = { enable = mkEnableOption "enable xrdp server"; };

  config = mkIf cfg.enable {
    services.xrdp = {
      enable = true;
      defaultWindowManager = "${pkgs.dwm}/bin/dwm";
    };
    networking.firewall.allowedTCPPorts = [ 3389 ];
  };
}
