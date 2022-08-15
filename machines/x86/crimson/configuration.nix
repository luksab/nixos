{ self, ... }: {
  networking.hostName = "crimson"; # Define your hostname.

  imports = [ ./amd_gpu.nix ./hardware.nix ];
  # ++ [ # enable for VM
  #   <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  #   <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
  # ];

  # allow aarch64 emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" ];

  networking.firewall.allowedTCPPorts = [ ];
  networking.firewall.allowedUDPPorts = [ ];

  luksab = {
    firmware.enable = true;
    desktop.enable = true;
    # disable wireguard for now
    # wireguard = {
    #   enable = true;
    #   ips = [ "10.31.69.101/24" ];
    #   allowedIPs = [ "10.31.69.0/24" ];
    #   # allowedIPs = [ "0.0.0.0/0" ];
    # };
  };

  boot = {
    loader = {
      grub = {
        enable = true;
        version = 2;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        useOSProber = true;
        memtest86.enable = true;
      };
    };
    cleanTmpDir = true;

    growPartition = true;
    initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    extraModulePackages = [ ];

    initrd.luks = {
      reusePassphrases = true;
      gpgSupport = true;
      devices = {
        root = {
          # lsblk -o +UUID
          # └─nvme0n1p2
          device = "/dev/disk/by-uuid/68e1ecd5-0cc9-4e62-85fe-6cd600b6de46";
          gpgCard = {
            publicKey = ../desktop/yubikey-public.asc;
            encryptedPass = ../desktop/pw.gpg;
          };
        };
      };
    };
  };

  virtualisation.docker = { enable = true; };

  networking.useDHCP = false;

  # blacklist acpi_cpufreq to use amd p states
  boot.kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];

  networking.networkmanager.enable = true;

  security.sudo.wheelNeedsPassword = true;

  # virtualisation = { # enable for VM
  #   diskSize = 8000; # MB
  #   memorySize = 2048; # MB
  #   # qemu.options = [
  #   #   "-virtfs local,path=${mount_host_path},security_model=none,mount_tag=${mount_tag}"
  #   # ];

  #   # We don't want to use tmpfs, otherwise the nix store's size will be bounded
  #   # by a fraction of available RAM.
  #   writableStoreUseTmpfs = false;
  # };

  fileSystems."/" = {
    # lsblk -o +UUID
    #      └─vg-root
    device = "/dev/disk/by-uuid/3f7994ed-4810-40d6-aca1-274b2736404f";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    # lsblk -o +UUID
    #      └─nvme0n1p1
    device = "/dev/disk/by-uuid/D9B0-E901";
    fsType = "vfat";
  };
}
