{ lib, config, pkgs, ... }:
with lib;

let cfg = config.luksab.xrdp;

in {
  options.luksab.xrdp = { enable = mkEnableOption "enable xrdp server"; };

  config = mkIf cfg.enable {
    services.xrdp = {
      enable = true;
      # defaultWindowManager = "${pkgs.dwm}/bin/dwm";
      defaultWindowManager = "startplasma-x11";
    };
    services.xserver.enable = true;
    # services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;
    networking.firewall.allowedTCPPorts = [ 3389 ];
  };
}
