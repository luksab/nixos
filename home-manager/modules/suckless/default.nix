{ lib, config, pkgs, fetchFromGitHub, ... }:
with lib;

let cfg = config.luksab.suckless;

in {
  options.luksab.suckless = {
    enable = mkEnableOption "enable suckless software";
  };

  config = mkIf cfg.enable {

    home.sessionVariables.BROWSER = if config.luksab.arch == "x86_64" then "brave" else "firefox";

    xresources = {
      properties = {
        "*.alpha" = "0.8";
        "*.font" = "monospace:size=12";
      };
    };

    # system.activationScripts = {
    #   text = ''
    #     chmod 0664 /sys/class/backlight/intel_backlight/brightness
    #     chown -cR root:video /sys/class/backlight/intel_backlight/brightness
    #   '';
    # };

    home.packages = with pkgs; [
      larbs_scripts
      dwm
      dmenu
      st
      dwmblocks

      xcompmgr
      feh
      acpi
      pamixer
      maim
      xclip
      notify-desktop
      lm_sensors
    ];
  };
}
