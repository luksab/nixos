inputs:
let
  # Pass flake inputs to overlay so we can use the sources pinned in flake.lock
  # instead of having to keep sha256 hashes in each package for src
  inherit inputs;
in self: super: {
  # Custom packages. Will be made available on all machines and used where
  # needed.
  larbs_scripts = super.pkgs.callPackage ../packages/larbs_scripts { };
  fabric-server = super.pkgs.callPackage ../packages/fabric-server { };
  overviewer = super.pkgs.callPackage ../packages/overviewer {
    # buildPythonApplication = super.python.pkgs.buildPythonApplication;
    # setuptools = super.python.pkgs.setuptools;
    wrapPython = super.python3.pkgs.wrapPython;
    makeWrapper = super.makeWrapper;
  };
  shortcut = super.pkgs.callPackage ../packages/shortcut { };
  wrapOBS = super.pkgs.callPackage ../packages/ndi/obs-wrapper.nix { };
  ndi = super.pkgs.callPackage ../packages/ndi { };
  davinci-resolve = super.pkgs.callPackage ../packages/davinci-resolve { };
  objectbox-bin = super.pkgs.callPackage ../packages/objectbox-bin { };
  #polymc = super.qt5.callPackage ../packages/polymc { };
  polymc = super.polymc.override {
    msaClientID = "d4434167-7a48-4be7-b463-647b1580e072";
  };
  obs-studio-plugins.obs-ndi = super.obs-studio-plugins.obs-ndi.overrideAttrs
    (old: { buildInputs = [ super.obs-studio super.qt5.qtbase self.ndi ]; });
  obs = (self.wrapOBS {
    plugins = with super.obs-studio-plugins; [
      self.obs-studio-plugins.obs-ndi
      self.stable.obs-studio-plugins.obs-websocket
      obs-move-transition
    ];
  });

  # override with newer version from nixpkgs-unstable
  # tautulli = self.unstable.tautulli;

  # fix for arm machines
  # spidermonkey_78 = self.master.spidermonkey_78;
  # polkit = self.master.polkit;

  # override with newer version from nixpkgs-unstable (home-manager related)
  # discord = self.master.discord;
  discord = super.pkgs.callPackage ../packages/discord { };
  discord_notify_go = super.pkgs.callPackage ../packages/discord_notify_go { };
  # cargo = self.unstable.cargo;
  # neovim-unwrapped = self.unstable.neovim-unwrapped;
  # obs-studio = self.unstable.obs-studio;
  # rpiplay = self.unstable.rpiplay;
  # signal-desktop = self.unstable.signal-desktop;
  # spotify = self.unstable.spotify;
  # vscode = self.unstable.vscode;
  # vscode-extensions = self.master.vscode-extensions;
  vsliveshare-new =
    super.pkgs.callPackage ../packages/ms-vsliveshare-vsliveshare { };
  deskreen = super.pkgs.callPackage ../packages/deskreen { };
  # krita = self.unstable.krita;
  # lutris = self.unstable.lutris;
  # youtube-dl = self.unstable.youtube-dl;
  # zoom-us = self.unstable.zoom-us;

  copilot-cmp = super.pkgs.callPackage ../packages/copilot-cmp { };
  copilot-vim = super.pkgs.callPackage ../packages/copilot-vim { };

  slock = super.pkgs.callPackage ../packages/slock { };
  # fprintd = super.pkgs.callPackage ../packages/fprintd { };
  lenovo_wwan_dpr = super.pkgs.callPackage ../packages/lenovo-wwan-dpr { };

  # suckless packages
  dwm = (super.dwm.overrideAttrs (oldAttrs: rec {
    src = super.pkgs.fetchFromGitHub {
      owner = "luksab";
      repo = "dwm";
      rev = "e5eef626223e5a566a90847e5c55cefccc9d0280";
      sha256 = "sha256-KZyMWRmbgIlAdktM3fsj+O6oZ/D4V7mMXqaCkxKGR/U=";
      name = "dwm";
    };
  }));

  dwmblocks = (super.dwmblocks.overrideAttrs (oldAttrs: rec {
    src = super.pkgs.fetchFromGitHub {
      owner = "LukeSmithxyz";
      repo = "dwmblocks";
      rev = "5a6fa8d550c11552480f10e660073ca294d446b1";
      sha256 = "sha256-3dutuQwYFg+oaIQ5cGL7lWapuzEWTeE/Kn0suEkCbLo=";
    };
    patches = [ ../packages/suckless/dwmblocks.patch ];
  }));

  dmenu = (super.dmenu.overrideAttrs (oldAttrs: rec {
    src = super.pkgs.fetchFromGitHub {
      owner = "LukeSmithxyz";
      repo = "dmenu";
      rev = "705b3c7c9f74fd1c370c6ed994e821135bb7acd4";
      sha256 = "sha256-AeG58ztzQ6WugV4nKwDTz+/Dqiq3dWUvkYXlkgh9YiY=";
    };
  }));

  st = (super.st.overrideAttrs (oldAttrs: rec {
    buildInputs = oldAttrs.buildInputs
      ++ [ super.pkgs.git super.pkgs.harfbuzz ];
    src = super.pkgs.fetchFromGitHub {
      owner = "LukeSmithxyz";
      repo = "st";
      rev = "ebf6f66fe1b9df9209e1e007622c628520f60f05";
      sha256 = "sha256-PzPNf8dRnMHr+NokWEnM2nsgOB86jpFeBuUVBLYYXdM=";
      name = "st";
    };
    # patches = [ ../packages/suckless/st.patch ];
    fetchSubmodules = true;
  }));

  vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
}
