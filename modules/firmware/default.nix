{ lib, config, pkgs, ... }:
with lib;
let cfg = config.luksab.firmware;
in
{
  options.luksab.firmware = {
    enable = mkEnableOption "enable redistributable firmware";
  };

  config = mkIf cfg.enable {
    hardware.enableRedistributableFirmware = mkDefault true;
    hardware.nvidia.package = pkgs.linuxPackages_5_15.nvidia_x11_beta;

    powerManagement.cpuFreqGovernor = mkDefault "powersave";
  };
}
