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

      (dwm.overrideAttrs (oldAttrs: rec {
        # src = pkgs.fetchFromGitHub {
        #   owner = "luksab";
        #   repo = "dwm";
        #   rev = "903a44eedcfd929f977a563482105436041daeaa";
        #   sha256 = "sha256-j3wCRyl1+0D2XcdqhE5Zgf53bEXhcaU4dvdyYG9LZ2g=";
        # };
        src = builtins.fetchTarball {
          url = "https://github.com/luksab/dwm/archive/master.tar.gz";
          sha256 = "sha256:0d8mvjd4x2s3j82q2wr4h6pwnqh5s7xw4iadxjhvw3fq1cqx9fpf";
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
        # Make sure you include whatever dependencies the fork needs to build properly!
        buildInputs = oldAttrs.buildInputs ++ [ git harfbuzz ];
        # If you want it to be always up to date use fetchTarball instead of fetchFromGitHub
        src = builtins.fetchTarball {
          url = "https://github.com/luksab/st/archive/master.tar.gz";
          sha256 = "sha256:127wxailsfqjlycjad7jaxx1ib4655k3w6c03fc7q3q8y9fd7j4x";
        };
        fetchSubmodules = true;
      }))
    ];
  };
}
