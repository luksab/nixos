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

      pamixer
      maim
      xclip
      notify-desktop

      (dwm.overrideAttrs (oldAttrs: rec {
        src = pkgs.fetchFromGitHub {
          owner = "luksab";
          repo = "dwm";
          rev = "5bb0ac1c7c9dd9917519f013bc84ce9f9fb49a43";
          sha256 = "sha256-+eXQeqC5OTJ9YS0SR9N39ekeaiiIEgvDDY+hJyfWChs=";
          name = "dwm";
        };
      }))

      (dwmblocks.overrideAttrs (oldAttrs: rec {
        src = pkgs.fetchFromGitHub {
          owner = "LukeSmithxyz";
          repo = "dwmblocks";
          rev = "66f31c307adbdcc2505239260ecda24a49eea7af";
          sha256 = "sha256-j3wCRyl1+0D2XcdqhE5Zgf53bEXhcaU4dvdyYG9LZ2g=";
        };
        patches = [ ./dwmblocks.patch ];
      }))

      lm_sensors

      (dmenu.overrideAttrs (oldAttrs: rec {
        src = pkgs.fetchFromGitHub {
          owner = "LukeSmithxyz";
          repo = "dmenu";
          rev = "3a6bc67fbd6df190b002d33f600a6465cad9cfb8";
          sha256 = "sha256-qwOcJqYGMftFwayfYA3XM0xaOo6ALV4gu1HpFRapbFg=";
        };
      }))

      (st.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ git harfbuzz ];
        src = pkgs.fetchFromGitHub {
          owner = "LukeSmithxyz";
          repo = "st";
          rev = "e053bd6036331cc7d14f155614aebc20f5371d3a";
          sha256 = "sha256-WwjuNxWoeR/ppJxJgqD20kzrn1kIfgDarkTOedX/W4k=";
          name = "st";
        };
        patches = [ ./st.patch ];
        fetchSubmodules = true;
      }))
    ];
  };
}
