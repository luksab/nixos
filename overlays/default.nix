self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.
  larbs_scripts = super.pkgs.callPackage ../packages/larbs_scripts { };

  # override with newer version from nixpkgs-unstable
  # tautulli = self.unstable.tautulli;

  # override with newer version from nixpkgs-unstable (home-manager related)
  discord = self.unstable.discord;
  neovim-unwrapped = self.unstable.neovim-unwrapped;
  wrapOBS = self.unstable.wrapOBS;
  obs-studio = self.unstable.obs-studio;
  obs-studio-plugins.obs-ndi = self.unstable.obs-studio-plugins.obs-ndi;
  ndi = self.unstable.ndi;
  signal-desktop = self.unstable.signal-desktop;
  spotify = self.unstable.spotify;
  vscode = self.unstable.vscode;
  youtube-dl = self.unstable.youtube-dl;
  zoom-us = self.unstable.zoom-us;

  # suckless packages
  dwm = (super.dwm.overrideAttrs (oldAttrs: rec {
    src = super.pkgs.fetchFromGitHub {
      owner = "luksab";
      repo = "dwm";
      rev = "5bb0ac1c7c9dd9917519f013bc84ce9f9fb49a43";
      sha256 = "sha256-+eXQeqC5OTJ9YS0SR9N39ekeaiiIEgvDDY+hJyfWChs=";
      name = "dwm";
    };
  }));

  dwmblocks = (super.dwmblocks.overrideAttrs (oldAttrs: rec {
    src = super.pkgs.fetchFromGitHub {
      owner = "LukeSmithxyz";
      repo = "dwmblocks";
      rev = "66f31c307adbdcc2505239260ecda24a49eea7af";
      sha256 = "sha256-j3wCRyl1+0D2XcdqhE5Zgf53bEXhcaU4dvdyYG9LZ2g=";
    };
    patches = [ ../modules/suckless/dwmblocks.patch ];
  }));

  dmenu = (super.dmenu.overrideAttrs (oldAttrs: rec {
    src = super.pkgs.fetchFromGitHub {
      owner = "LukeSmithxyz";
      repo = "dmenu";
      rev = "3a6bc67fbd6df190b002d33f600a6465cad9cfb8";
      sha256 = "sha256-qwOcJqYGMftFwayfYA3XM0xaOo6ALV4gu1HpFRapbFg=";
    };
  }));

  st = (super.st.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs ++ [ super.pkgs.git super.pkgs.harfbuzz ];
    src = super.pkgs.fetchFromGitHub {
      owner = "LukeSmithxyz";
      repo = "st";
      rev = "e053bd6036331cc7d14f155614aebc20f5371d3a";
      sha256 = "sha256-WwjuNxWoeR/ppJxJgqD20kzrn1kIfgDarkTOedX/W4k=";
      name = "st";
    };
    patches = [ ../modules/suckless/st.patch ];
    fetchSubmodules = true;
  }));
}
