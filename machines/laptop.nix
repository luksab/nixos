{ config, lib, pkgs, modulesPath, ... }:

{
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix") ../suckless.nix ];
  environment.systemPackages = with pkgs; [ firefox brave spotify discord ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/nvme0n1";

  networking.interfaces.wlp0s20f3.useDHCP = true;

  networking.wireless.enable = true;
  networking.wireless.interfaces = [ "wlp0s20f3" ];

  home-manager.users.lukas = {
    xsession.enable = true;
    xsession.windowManager.command = "dwm";
  };

  networking.wireless.networks = {
    Salami = { # SSID with no spaces or special characters
      psk = "ckqc-go05-m2kn";
    };
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;

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

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
