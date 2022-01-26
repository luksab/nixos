{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.ssh;

in {
  options.luksab.ssh.enable = mkEnableOption "enable ssh config";
  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      matchBlocks."*".extraOptions = { "StrictHostKeyChecking" = "accept-new"; };
    };
  };
}
