{ lib, config, pkgs, ... }:
with lib;
let cfg = config.luksab.desktop;
in {
  options.luksab.desktop = { enable = mkEnableOption "enable desktop"; };

  config = mkIf cfg.enable {
    # Enable sound.
    sound.enable = true;
    hardware.pulseaudio.enable = true;

    # enable yubi key
    mayniklas.yubikey.enable = true;

    programs.dconf.enable = true;
    services.gvfs.enable = true;

    luksab = {
      common.enable = true;
      xserver = {
        enable = true;
        dpi = 100;
      };
      v4l2loopback.enable = true;
      ndi.enable = true;
      steam.enable = config.luksab.arch == "x86_64";
    };
  };
}
