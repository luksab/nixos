{ lib, config, pkgs, ... }:
with lib;
let cfg = config.luksab.firmware;
in {
  options.luksab.firmware = {
    enable = mkEnableOption "enable redistributable firmware";
  };

  config = mkIf cfg.enable {
    hardware.enableRedistributableFirmware = mkDefault true;
    boot.kernelPackages = pkgs.linuxPackages_5_14;

    powerManagement.cpuFreqGovernor = mkDefault "powersave";
  };
}
