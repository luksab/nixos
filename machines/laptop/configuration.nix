# { config, lib, pkgs, modulesPath, ... }: {
{ self, ... }: {
  networking.hostName = "laptop"; # Define your hostname.

  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  #allow aarch64 emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  home-manager.users.lukas = {
    imports = [
      ../../home-manager/home.nix
      { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
    ];
  };

  luksab = {
    firmware.enable = true;
    desktop.enable = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.networkmanager.enable = true;

  # {
  #   xsession.enable = true;
  #   xsession.windowManager.command = "dwm";
  #   #xsession.scriptPath = ".hm-xsession";
  # };

  hardware.acpilight.enable = true;
  security.sudo.wheelNeedsPassword = false;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/a8633e60-6627-46be-b692-86b8ada20793";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/251C-6023";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/3a854087-060e-4cc8-ab64-9045c31d26d0"; }];
}
