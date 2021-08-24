{ config, pkgs, ... }:
let

in {
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.command-not-found.enable = true;

  luksab = {
    programs.vim.enable = true;
    programs.vscode.enable = true;
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "lukas";
  home.homeDirectory = "/home/lukas";

  # Allow "unfree" licenced packages
  nixpkgs.config = { allowUnfree = true; };

  # Install these packages for my user
  home.packages = with pkgs; [
    brave
    spotify
    discord
    brightnessctl
    htop
    multimc
    enpass

    dolphin
    filezilla
    gcc
    gnome3.dconf
    gparted
    iperf3
    nmap
    obs-studio
    signal-desktop
    spotify
    unzip
    vim
    vlc
    youtube-dl
    zoom-us
  ];

  # Imports
  imports = [
    ./modules/devolopment
    ./modules/git
    ./modules/gtk
    ./modules/vim
    ./modules/vscode
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
  home.stateVersion = "21.05";
}
