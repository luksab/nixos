{ lib, config, ... }:
with lib;
let cfg = config.luksab.firmware;
in {
  options.luksab.firmware = {
    enable = mkEnableOption "enable redistributable firmware";
  };

  config = mkIf cfg.enable {
    hardware.enableRedistributableFirmware = mkDefault true;

    powerManagement.cpuFreqGovernor = mkDefault "powersave";
  };
}
