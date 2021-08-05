{ config, pkgs, ... }:

{
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.startx.enable = true;
  environment.systemPackages = with pkgs;
    [
      (dwm.overrideAttrs (oldAttrs: rec {
        patches = [
          # You can specify local patches
        #   ./path/to/local.diff
        #   # Fetch them directly from `st.suckless.org`
        #   (fetchpatch {
        #     url =
        #       "https://st.suckless.org/patches/rightclickpaste/st-rightclickpaste-0.8.2.diff";
        #     sha256 = "1y4fkwn911avwk3nq2cqmgb2rynbqibgcpx7yriir0lf2x2ww1b6";
        #   })
        #   # Or from any other source
        #   (fetchpatch {
        #     url =
        #       "https://raw.githubusercontent.com/fooUser/barRepo/1111111/somepatch.diff";
        #     sha256 = "222222222222222222222222222222222222222222";
        #   })
        ];
      }))
    ];

}
