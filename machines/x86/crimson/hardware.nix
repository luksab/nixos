{ lib, config, pkgs, ... }: {
  # For suspending to RAM, set Config -> Power -> Sleep State to "Linux" in EFI.

  # amdgpu.backlight=0 makes the backlight work
  # acpi_backlight=none allows the backlight save/load systemd service to work.
  boot.kernelParams = [ "amdgpu.backlight=0" "acpi_backlight=none" ];

  boot.blacklistedKernelModules = [ "raydium_i2c_ts" ];

  # Wifi support
  hardware.firmware = [ pkgs.rtw89-firmware ];

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "schedutil";

  boot = {
    kernelModules = [ "acpi_call" "amd-pstate" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}
