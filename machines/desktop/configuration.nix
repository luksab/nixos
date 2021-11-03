{ self, ... }: {
  networking.hostName = "desktop"; # Define your hostname.

  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  # allow aarch64 emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" ];
  # ntfs support
  boot.supportedFilesystems = [ "ntfs" ];

  home-manager.users.lukas = {
    imports = [
      ../../home-manager/home.nix
      {
        nixpkgs.overlays =
          [ self.overlay self.overlay-unstable self.overlay-master ];
      }
    ];
  };

  luksab = {
    firmware.enable = true;
    desktop.enable = true;
    wireguard = {
      enable = true;
      ip = "10.31.69.101/24";
    };
  };

  # mayniklas.grub-luks = {
  #   enable = true;
  #   uuid = "dc9c877a-a56c-49b5-bb5a-a1f9a17b8296";
  # };

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
      };
    };
    cleanTmpDir = true;

    initrd.luks = {
      reusePassphrases = true;
      gpgSupport = true;
      devices = {
        root = {
          # Get UUID from blkid /dev/sda2
          device = "/dev/disk/by-uuid/dc9c877a-a56c-49b5-bb5a-a1f9a17b8296";
          gpgCard = {
            publicKey = ./yubikey-public.asc;
            encryptedPass = ./pw.gpg;
          };
        };
      };
    };
  };

  services.xserver = { videoDrivers = [ "nvidia" ]; };

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };
  # Fix docker Nvidia
  systemd.enableUnifiedCgroupHierarchy = false;
  virtualisation.podman.enable = true;

  networking.useDHCP = false;
  networking.nameservers = [ "1.1.1.1" ];

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp7s0.useDHCP = true;

  networking.networkmanager.enable = true;

  security.sudo.wheelNeedsPassword = false;

  boot.initrd.availableKernelModules =
    [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/2e3bada6-77cb-4a06-9823-dc1ffef5d3de";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/543A-E53E";
    fsType = "vfat";
  };
}
