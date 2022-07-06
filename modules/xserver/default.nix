{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.xserver;
in
{

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
    # Enable X forwarding
    programs.ssh = {
      forwardX11 = true;
      setXAuthLocation = true;
    };

    services.openssh.forwardX11 = true;

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

      windowManager.dwm.enable = true;

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

      displayManager.autoLogin = {
        enable = true;
        user = "lukas";
      };

      displayManager.defaultSession = "none+dwm";

      displayManager.lightdm = {
        enable = true;
        greeters.gtk.iconTheme = {
          package = pkgs.libsForQt5.breeze-gtk;
          name = "Breeze-gtk";
        };
      };
    };
  };
}
