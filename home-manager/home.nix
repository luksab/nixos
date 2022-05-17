{ lib, config, pkgs, ... }:
let

in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.command-not-found.enable = true;
  programs.password-store.enable = true;

  luksab = {
    suckless.enable = true;
    # mime.enable = true;
    services.dunst.enable = true;
    ssh.enable = true;
    #programs.vim.enable = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lukas";
  home.homeDirectory = "/home/lukas";

  xsession = {
    enable = true;
    windowManager.command = "dwm";
    initExtra = ''
      .screenlayout/default.sh &
      ${pkgs.xcompmgr}/bin/xcompmgr &
      ${pkgs.feh}/bin/feh --bg-fill --randomize Pictures/backgrounds

      xrandr --newmode "2384x1577" 319.61  2384 2560 2824 3264  1577 1578 1581 1632  -HSync +Vsync
      xrandr --addmode VIRTUAL1 2384x1577

      xrandr --newmode "1904x1259"  201.39  1904 2032 2240 2576  1259 1260 1263 1303  -HSync +Vsync
      xrandr --addmode VIRTUAL1 1904x1259
    '';
  };

  # Remove in next release of home-manager
  home.file.".icons/default/index.theme".text = ''
    [icon theme]
    Name=Default
    Comment=Default Cursor Theme
    Inherits=Adwaita
  '';
  # home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";

  services.unclutter = {
    enable = true;
    timeout = 5;
  };

  # enable bluetooth media control
  services.mpris-proxy.enable = true;

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Install these packages for my user
  home.packages = with pkgs; [
    libnotify
    brightnessctl
    htop
    polymc
    arandr

    dolphin
    gnome.nautilus
    gnome.file-roller
    mtools
    sshfs
    filezilla
    glib
    glibc
    coreutils
    dconf
    gparted
    iperf3
    nmap
    (lib.mkIf (config.luksab.arch == "x86_64") signal-desktop)
    unzip
    vim
    vlc
    youtube-dl
    foliate
    pavucontrol
    cloc
    krita
    gnome.gnome-system-monitor
    dig
    traceroute

    jdk
    ansible
    vagrant
    cargo
    rustc
    clang
    rustfmt
    clippy
    file

    gcr
    xournalpp
    prusa-slicer
    element-desktop
    rhythmbox
    # davinci-resolve
    kdenlive
    firefox
    pdfpc
    # kicad-small

    code-server
    x11vnc

    deskreen
  ];

  # Certain Rust tools won't work without this
  # This can also be fixed by using oxalica/rust-overlay and specifying the rust-src extension
  # See https://discourse.nixos.org/t/rust-src-not-found-and-other-misadventures-of-developing-rust-on-nixos/11570/3?u=samuela. for more details.
  home.sessionVariables.RUST_SRC_PATH =
    "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";

  luksab.x86.enable = config.luksab.arch == "x86_64";
  luksab.programs.vscode.enable = true;

  # Imports
  imports = [
    #./modules/devolopment
    ./modules/git
    # ./modules/gtk
    ../modules/options
    ./modules/suckless
    ./modules/dunst
    ./modules/mime
    ./modules/zsh
    ./modules/vscode
    ./modules/x86
    ./modules/ssh
  ];

  services.gnome-keyring = { enable = true; };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
