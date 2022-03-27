{ lib, config, pkgs, ... }:
with lib;

let cfg = config.luksab.scrcpy;

in {
  options.luksab.scrcpy = { enable = mkEnableOption "enable scrcpy software"; };

  config = mkIf cfg.enable {

    programs.adb.enable = true;
    users.users.lukas.extraGroups = [ "adbusers" ];

    environment.systemPackages = with pkgs; [ scrcpy ];
  };
}
