# { config, lib, pkgs, modulesPath, ... }: {
{ self, ... }: {
  networking.hostName = "laptop"; # Define your hostname.

  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  #allow aarch64 emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" ];

  home-manager.users.lukas = {
    imports = [
      ../../home-manager/home.nix
      ../../home-manager/modules/touchscreen
      { nixpkgs.overlays = [ self.overlay self.overlay-master self.overlay-stable ]; }
    ];
  };

  luksab = {
    firmware.enable = true;
    desktop.enable = true;
    wireguard = {
      enable = true;
      ips = [ "10.31.69.107/24" ];
      allowedIPs = [ "10.31.69.0/24" ];
    };
    nameserver.enable = true;
  };

  services.xserver.screenSection = ''
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  virtualisation.docker.enable = true;

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
          device = "/dev/disk/by-uuid/b0ce5b0a-840c-4fdd-849c-95ed17e228b6";
          gpgCard = {
            publicKey = ../desktop/yubikey-public.asc;
            encryptedPass = ../desktop/pw.gpg;
          };
        };
      };
    };
  };

  networking.useDHCP = false;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  # networking.wireless.enable = true;
  # networking.wireless.interfaces = [ "wlp0s20f3" ];
  # networking.wireless.networks = {
  #   Salami = { # SSID with no spaces or special characters
  #     psk = "ckqc-go05-m2kn";
  #   };
  # };
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
    device = "/dev/disk/by-uuid/d4e57c25-111e-4e58-8a46-5381cb2b6cd6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/68CA-410A";
    fsType = "vfat";
  };
}
