{ lib, config, pkgs, ... }:
with lib;
let cfg = config.luksab.v4l2loopback;
in {
  options.luksab.v4l2loopback = { enable = mkEnableOption "enable desktop"; };

  config = mkIf cfg.enable {
    # load v4l2loopback
    boot.extraModulePackages = with unstable;
      [ config.boot.kernelPackages.v4l2loopback ];
    # Register a v4l2loopback device at boot
    boot.kernelModules = [ "v4l2loopback" ];

    boot.extraModprobeConfig = ''
      options v4l2loopback exclusive_caps=1 video_nr=9 card_label=obs
    '';
  };
}
