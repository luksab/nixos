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

  dwm = (super.dwm.overrideAttrs (oldAttrs: rec {
    src = super.pkgs.fetchFromGitHub {
      owner = "luksab";
      repo = "dwm";
      rev = "5bb0ac1c7c9dd9917519f013bc84ce9f9fb49a43";
      sha256 = "sha256-+eXQeqC5OTJ9YS0SR9N39ekeaiiIEgvDDY+hJyfWChs=";
      name = "dwm";
    };
  }));
}
