{ self, ... }: {
  networking.hostName = "crimson"; # Define your hostname.

  imports = [ ];
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
    # initrd.kernelModules = [ "dm-snapshot" ];
    # kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

    initrd.luks = {
      reusePassphrases = true;
      gpgSupport = true;
      devices = {
        root = {
          # lsblk -o +UUID
          # └─nvme0n1p2
          device = "/dev/disk/by-uuid/dc9c877a-a56c-49b5-bb5a-a1f9a17b8296";
          gpgCard = {
            publicKey = ./yubikey-public.asc;
            encryptedPass = ./pw.gpg;
          };
        };
      };
    };
  };

  virtualisation.docker = { enable = true; };

  networking.useDHCP = false;

  # networking.interfaces.eno1.useDHCP = true;
  # networking.interfaces.enp8s0.useDHCP = true;
  # networking.interfaces.wlp7s0.useDHCP = true;

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
    device = "/dev/disk/by-uuid/0ff11b4a-f7f8-4eba-90c4-4cef4a87dc33";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    # lsblk -o +UUID
    #      └─nvme0n1p1
    device = "/dev/disk/by-uuid/4D62-2CB3";
    fsType = "vfat";
  };
}
