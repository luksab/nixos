{ lib, config, pkgs, fetchFromGitHub, ... }:
with lib;

let cfg = config.luksab.suckless;

in {
  options.luksab.suckless = {
    enable = mkEnableOption "enable suckless software";
  };

  config = mkIf cfg.enable {

    # system.activationScripts = {
    #   text = ''
    #     chmod 0664 /sys/class/backlight/intel_backlight/brightness
    #     chown -cR root:video /sys/class/backlight/intel_backlight/brightness
    #   '';
    # };

    environment.systemPackages = with pkgs; [
      larbs_scripts
      dwm
      dmenu
      st
      dwmblocks

      pamixer
      maim
      xclip
      notify-desktop
      lm_sensors
    ];
  };
}
