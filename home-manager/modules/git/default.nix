{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;

      userEmail = "lukas@sabatschus.de";
      userName = "luksab";
      signing = {
        key = "9C083CECA78B772E";
        signByDefault = true;
      };      
    };
  };
}
