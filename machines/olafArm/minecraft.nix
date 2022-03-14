{ lib, config, pkgs, ... }: {
  luksab.minecraft-server = {
    enable = true;
    openFirewall = true;
    javaPackage = pkgs.jre;
    serverFile = "server.jar";
  };
}
