{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.xserver;
in {

  options.luksab.xserver = {
    enable = mkEnableOption "activate xserver";
    dpi = mkOption {
      type = types.int;
      default = 125;
      description = ''
        screen DPI
      '';
    };
  };

  config = mkIf cfg.enable {

    # Enable the X11 windowing system.
    services.xserver = {
      layout = "de";
      xkbOptions = "eurosign:e";
      enable = true;
      autorun = true;
      dpi = cfg.dpi;
      libinput = {
        enable = true;
        touchpad.accelProfile = "adaptive";
        touchpad.accelSpeed = "-0.15";
      };

      desktopManager = {
        xterm.enable = false;
        session = [{
          name = "home-manager";
          start = ''
            export `dbus-launch`
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
             waitPID=$!
          '';
        }];
      };

      displayManager.lightdm = {
        enable = true;
        greeters.gtk.iconTheme = {
          package = pkgs.gnome-breeze;
          name = "Breeze-gtk";
        };
      };
    };
  };
}
