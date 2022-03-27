{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.openssh;
in {

  options.luksab.openssh = { enable = mkEnableOption "activate openssh"; };

  config = mkIf cfg.enable {

    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      startWhenNeeded = true;
      kbdInteractiveAuthentication = false;
      allowSFTP = true;
    };

    # Enable mosh
    programs.mosh.enable = true;

  };
}
