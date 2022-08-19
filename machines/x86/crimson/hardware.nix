{ lib, config, pkgs, ... }: {
  # For suspending to RAM, set Config -> Power -> Sleep State to "Linux" in EFI.

  # amdgpu.backlight=0 makes the backlight work
  # acpi_backlight=none allows the backlight save/load systemd service to work.
  boot.kernelParams = [ "amdgpu.backlight=0" "acpi_backlight=none" ];

  boot.blacklistedKernelModules = [ "raydium_i2c_ts" ];

  systemd.user.services.configure_touch = {
    path = [ pkgs.xorg.xinput ];
    script = builtins.readFile ./configure_touch.sh;
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
  };

  # Wifi support
  hardware.firmware = [ pkgs.rtw89-firmware ];

  powerManagement.enable = true;
  powerManagement.cpuFreqGovernor = "conservative";

  boot = {
    kernelModules = [ "acpi_call" "amd-pstate" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
  };
}
