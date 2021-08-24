self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.
  larbs_scripts = super.pkgs.callPackage ../packages/larbs_scripts { };

  # override with newer version from nixpkgs-unstable
  # tautulli = self.unstable.tautulli;

  # override with newer version from nixpkgs-unstable (home-manager related)
  discord = self.unstable.discord;
  neovim-unwrapped = self.unstable.neovim-unwrapped;
  obs-studio = self.unstable.obs-studio;
  signal-desktop = self.unstable.signal-desktop;
  spotify = self.unstable.spotify;
  vscode = self.unstable.vscode;
  youtube-dl = self.unstable.youtube-dl;
  zoom-us = self.unstable.zoom-us;
}