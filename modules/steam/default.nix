{ config, lib, pkgs, ... }:

with lib;

let cfg = config.luksab.steam;
in {
  options.luksab.steam.enable = mkEnableOption "steam";

  config = mkIf cfg.enable {
    hardware.opengl =
      { # this fixes the "glXChooseVisual failed" bug, context: https://github.com/NixOS/nixpkgs/issues/47932
        enable = true;
        driSupport32Bit = true;
      };

    # optionally enable 32bit pulseaudio support if pulseaudio is enabled
    hardware.pulseaudio.support32Bit = config.hardware.pulseaudio.enable;

    hardware.steam-hardware.enable = true;

    environment.systemPackages = [ pkgs.gnome3.adwaita-icon-theme pkgs.lutris ];
    programs.steam.enable = true;
  };
}
