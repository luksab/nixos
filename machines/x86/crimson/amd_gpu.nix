{ lib, config, pkgs, ... }: {
  # AMD GPU stuff
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver = {
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''
      Option         "TearFree" "true"
    '';
  };

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
    driversi686Linux.amdvlk
  ];
  hardware.opengl.driSupport = true;
  # For 32 bit applications
  hardware.opengl.driSupport32Bit = true;
}
