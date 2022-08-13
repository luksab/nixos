{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.user.root;
in
{
  options.luksab.user.root = { enable = mkEnableOption "activate root user"; };

  config = mkIf cfg.enable {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.root = {
      openssh.authorizedKeys.keyFiles = [
        (builtins.fetchurl {
          url = "https://github.com/luksab.keys";
          sha256 =
            "sha256:01mk365sgizs2iq4w7zjrxqc8jkaii82p7w5nhcjxpv8dzx24pda";
        })
      ];
    };
  };
}
