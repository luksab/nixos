{ config, pkgs, lib, ... }: {
  programs = {
    git = {
      enable = true;

      userEmail = "lukas@sabatschus.de";
      userName = "luksab";
      signing = {
        key = "6F66F20BF7E9FDD4";
        signByDefault = true;
      };
      lfs.enable = true;
    };
  };
}
