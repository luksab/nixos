{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.user.emma.home-manager;

in
{
  options.luksab.user.emma.home-manager = {
    enable = mkEnableOption "activate headless home-manager profile for emma";
  };

  config = mkIf cfg.enable {
    home-manager.useUserPackages = true;

    home-manager.users.emma = {
      programs.home-manager.enable = true;

      programs.command-not-found.enable = true;

      # Home Manager needs a bit of information about you and the
      # paths it should manage.
      home.username = "emma";
      home.homeDirectory = "/home/emma";

      luksab = {
        programs.vim.enable = true;
      };

      # Allow "unfree" licenced packages
      nixpkgs.config = { allowUnfree = true; };

      services = {
        syncthing = {
          enable = true;
          extraOptions = [ "--gui-address=0.0.0.0:8384" ];
        };
      };

      # Install these packages for my user
      home.packages = with pkgs; [
        screen
        htop

        iperf3
        nmap
        unzip
        youtube-dl
        cloc
        dig
        traceroute

        jdk
        code-server
      ];

      # Imports
      imports = [
        ./modules/vim
        ../modules/options
        ./modules/git
        ./modules/zsh
      ];

      # This value determines the Home Manager release that your
      # configuration is compatible with. This helps avoid breakage
      # when a new Home Manager release introduces backwards
      # incompatible changes.
      #
      # You can update Home Manager without changing this value. See
      # the Home Manager release notes for a list of state version
      # changes in each release.
      home.stateVersion = "21.11";
    };
  };
}
