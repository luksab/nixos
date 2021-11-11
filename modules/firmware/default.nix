{ lib, config, pkgs, ... }:
with lib;
let cfg = config.luksab.firmware;
in {
  options.luksab.firmware = {
    enable = mkEnableOption "enable redistributable firmware";
  };

  config = mkIf cfg.enable {
    hardware.enableRedistributableFirmware = mkDefault true;
    # boot.kernelPackages = pkgs.linuxPackages_5_14;
    # hardware.nvidia.package = pkgs.linuxPackages_5_14.nvidia_x11_beta;

    powerManagement.cpuFreqGovernor = mkDefault "powersave";
  };
}
