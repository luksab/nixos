{ lib, config, pkgs, ... }:
with lib;

let cfg = config.luksab.suckless;

in {
  options.luksab.suckless = {
    enable = mkEnableOption "enable suckless software";
  };

  config = mkIf cfg.enable {
    # Enable touchpad support (enabled default in most desktopManager).
    services.xserver.libinput.enable = true;

    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.autorun = true;

    # Use the home-manager config as xsession
    services.xserver.desktopManager.session = [{
      name = "home-manager";
      start = ''
        ${pkgs.runtimeShell} $HOME/.hm-xsession &
        waitPID=$!
      '';
    }];

    # system.activationScripts = {
    #   text = ''
    #     chmod 0664 /sys/class/backlight/intel_backlight/brightness
    #     chown -cR root:video /sys/class/backlight/intel_backlight/brightness
    #   '';
    # };

    environment.systemPackages = with pkgs; [
      larbs

      pamixer

      (dwm.overrideAttrs (oldAttrs: rec {
        src = builtins.fetchTarball {
          url = "https://github.com/luksab/dwm/archive/master.tar.gz";
        };
      }))

      (dwmblocks.overrideAttrs (oldAttrs: rec {
        src = builtins.fetchTarball {
          url =
            "https://github.com/LukeSmithxyz/dwmblocks/archive/master.tar.gz";
        };
        patches = [ ./dwmblocks.patch ];
      }))

      lm_sensors

      (dmenu.overrideAttrs (oldAttrs: rec {
        src = builtins.fetchTarball {
          url = "https://github.com/LukeSmithxyz/dmenu/archive/master.tar.gz";
        };
      }))

      (st.overrideAttrs (oldAttrs: rec {
        # Make sure you include whatever dependencies the fork needs to build properly!
        buildInputs = oldAttrs.buildInputs ++ [ git harfbuzz ];
        # If you want it to be always up to date use fetchTarball instead of fetchFromGitHub
        src = builtins.fetchTarball {
          url = "https://github.com/luksab/st/archive/master.tar.gz";
        };
        fetchSubmodules = true;
      }))
    ];
  };
}
