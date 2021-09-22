{ lib, config, pkgs, ... }: {
  luksab.minecraft-server = {
    enable = true;
    openFirewall = true;
    javaPackage = pkgs.jre8;
    serverFile = "serverstarter-2.0.1.jar";
  };
}
