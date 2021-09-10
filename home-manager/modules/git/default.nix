{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;

      userEmail = "luksablp@gmail.com";
      userName = "luksab";
      signing = {
        key = "9C083CECA78B772E";
        signByDefault = true;
      };      
    };
  };
}
