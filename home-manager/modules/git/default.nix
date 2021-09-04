{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;

      userEmail = "luksablp@gmail.com";
      userName = "luksab";
    };
  };
}
