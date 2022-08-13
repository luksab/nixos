{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.user.lukas;
in
{
  options.luksab.user.lukas = {
    enable = mkEnableOption "activate user lukas";
  };

  config = mkIf cfg.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.lukas = {
      isNormalUser = true;
      home = "/home/lukas";
      extraGroups = [
        "wheel"
        "video"
        "networkmanager"
        "docker"
        "dialout"
        "usb"
      ]; # Enable ‘sudo’ for the user.
      # password = "123"; # enable for testing in VM
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = [
        (builtins.fetchurl {
          url = "https://github.com/luksab.keys";
          sha256 =
            "sha256:01mk365sgizs2iq4w7zjrxqc8jkaii82p7w5nhcjxpv8dzx24pda";
        })
      ];
    };

    nix.settings.allowed-users = [ "lukas" ];
  };
}
