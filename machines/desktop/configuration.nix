# { config, lib, pkgs, modulesPath, ... }: {
{ self, ... }: {
  networking.hostName = "desktop"; # Define your hostname.

  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  #allow aarch64 emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" ];

  home-manager.users.lukas = {
    imports = [
      ../../home-manager/home.nix
      ../../home-manager/modules/touchscreen
      { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
    ];
  };

  luksab = {
    firmware.enable = true;
    desktop.enable = true;
  };

  mayniklas.grub-luks = {
    enable = true;
    uuid = "537339b4-6da6-4938-b803-fd06b1bde749";
  };

  services.xserver = { videoDrivers = [ "nvidia" ]; };

  virtualisation.docker.enable = true;

  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp0s20f0u4u3.useDHCP = true;
  networking.interfaces.enp14s0.useDHCP = true;
  networking.interfaces.enp9s0.useDHCP = true;
  networking.interfaces.wlp8s0.useDHCP = true;

  security.sudo.wheelNeedsPassword = false;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/4197a2f3-4764-438c-94ff-74e4e326c906";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/543A-E53E";
      fsType = "vfat";
    };
}
