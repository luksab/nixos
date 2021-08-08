{ config, pkgs, ... }:

let larbs = pkgs.callPackage ./pkgs/larbs_scripts.nix { };

in {
  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  #services.xserver.windowManager.dwm.enable = true;

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
        url = "https://github.com/LukeSmithxyz/dwmblocks/archive/master.tar.gz";
      };
    }))

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
}
