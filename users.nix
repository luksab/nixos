{ config, lib, pkgs, modulesPath, ... }:

let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "b39647e52ed3c0b989e9d5c965e598ae4c38d7ef"; # CHANGEME
    ref = "release-21.05";
  };
in {
  imports = [ (import "${home-manager}/nixos") ];
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukas = {
    isNormalUser = true;
    home = "/home/lukas";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles =
      [ (builtins.fetchurl { url = "https://github.com/luksab.keys"; }) ];
  };

  home-manager.users.lukas = {
    programs.home-manager.enable = true;
    home.username = "lukas";
    home.homeDirectory = "/home/lukas";

    programs.git = {
      enable = true;
      userName = "luksab";
      userEmail = "luksablp@gmail.com";
    };

    home.stateVersion = "21.05";
  };

  users.users.root = {
    shell = pkgs.fish;
    openssh.authorizedKeys.keyFiles =
      [ (builtins.fetchurl { url = "https://github.com/luksab.keys"; }) ];
  };
  nix.allowedUsers = [ "lukas" ];
}
