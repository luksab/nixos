{ self, ... }: {
  networking.hostName = "desktop"; # Define your hostname.

  imports = [ ./nameserver.nix ];
  # ++ [ # enable for VM
  #   <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
  #   <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
  # ];

  # allow aarch64 emulation
  boot.binfmt.emulatedSystems = [ "aarch64-linux" "armv6l-linux" ];
  # ntfs support
  boot.supportedFilesystems = [ "ntfs" ];

  networking.firewall.allowedTCPPorts = [ 24800 ];

  luksab = {
    firmware.enable = true;
    desktop.enable = true;
    wireguard = {
      enable = true;
      ips = [ "10.31.69.101/24" ];
      allowedIPs = [ "10.31.69.0/24" ];
      # allowedIPs = [ "0.0.0.0/0" ];
    };
    shortcut.enable = true;
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
        memtest86.enable = true;
      };
    };
    cleanTmpDir = true;

    growPartition = true;
    initrd.availableKernelModules =
      [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ "dm-snapshot" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];

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
  # systemd.enableUnifiedCgroupHierarchy = false;
  virtualisation.podman.enable = true;

  networking.useDHCP = false;

  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp7s0.useDHCP = true;

  networking.networkmanager.enable = true;

  security.sudo.wheelNeedsPassword = false;

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
    device = "/dev/disk/by-uuid/0ff11b4a-f7f8-4eba-90c4-4cef4a87dc33";
    fsType = "ext4";
    autoResize = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/4D62-2CB3";
    fsType = "vfat";
  };

  #SAMBA qmk
  services.samba-wsdd.enable =
    true; # make shares visible for windows 10 clients
  networking.firewall.interfaces.virbr0.allowedTCPPorts = [
    5357 # wsdd
  ];
  networking.firewall.interfaces.virbr0.allowedUDPPorts = [
    3702 # wsdd
  ];
  services.samba = {
    enable = true;
    securityType = "user";
    # openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = smbnix
      netbios name = smbnix
      security = user 
      #use sendfile = yes
      #max protocol = smb2
      # note: localhost is the ipv6 localhost ::1
      hosts allow = 192.168.122.1/24 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      public = {
        path = "/home/lukas/qmk_firmware/";
        browseable = "yes";
        "read only" = "yes";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        # "force user" = "lukas";
        # "force group" = "groupname";
      };
    };
  };
}
