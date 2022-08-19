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

  # enroll with `sudo fprintd-enroll lukas`
  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

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

  # Automatically configure monitors with autorandr
  services.autorandr = {
    enable = true;
    # autorandr --fingerprint
    profiles = {
      "work" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d3200000000141c0104a51f117803f5658f555a932a1f505400000001010101010101010101010101010101773f803c7138824010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414b30332e32200a001d";
          DisplayPort-3 =
            "00ffffffffffff004c2d710f594858430a1f0103805021782a46c5a5564f9b250f5054bfef80714f810081c081809500a9c0b3000101e77c70a0d0a0295030203a001d4d3100001a000000fd00324b1e7829000a202020202020000000fc005333344a3535780a2020202020000000ff0048344c523330313130330a2020012f020324f147001f041303125a230907078301000067030c002000803c67d85dc4015280009d6770a0d0a0225030203a001d4d3100001a584d00b8a1381440f82c45001d4d3100001e565e00a0a0a02950302035001d4d3100001a023a801871382d40582c45001d4d3100001e539d70a0d0a0345030203a001d4d3100001a00f0";
        };
        config = {
          eDP = {
            enable = true;
            mode = "1920x1080";
          };
          DisplayPort-3 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "1920x0";
            mode = "3440x1440";
            rate = "60.00";
          };
          DisplayPort-5 = {
            enable = false;
          };
        };
        hooks.postswitch = {
          "configure_touch" =
            builtins.readFile ./configure_touch.sh;
        };
      };
      "work2" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d3200000000141c0104a51f117803f5658f555a932a1f505400000001010101010101010101010101010101773f803c7138824010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414b30332e32200a001d";
          DisplayPort-2 =
            "00ffffffffffff004c2d710f594858430a1f0103805021782a46c5a5564f9b250f5054bfef80714f810081c081809500a9c0b3000101e77c70a0d0a0295030203a001d4d3100001a000000fd00324b1e7829000a202020202020000000fc005333344a3535780a2020202020000000ff0048344c523330313130330a2020012f020324f147001f041303125a230907078301000067030c002000803c67d85dc4015280009d6770a0d0a0225030203a001d4d3100001a584d00b8a1381440f82c45001d4d3100001e565e00a0a0a02950302035001d4d3100001a023a801871382d40582c45001d4d3100001e539d70a0d0a0345030203a001d4d3100001a00f0";
        };
        config = {
          eDP = {
            enable = true;
            mode = "1920x1080";
          };
          DisplayPort-2 = {
            enable = true;
            crtc = 0;
            primary = true;
            position = "1920x0";
            mode = "3440x1440";
            rate = "60.00";
          };
          DisplayPort-5 = {
            enable = false;
          };
        };
        hooks.postswitch = {
          "configure_touch" =
            builtins.readFile ./configure_touch.sh;
        };
      };
      "laptop" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d3200000000141c0104a51f117803f5658f555a932a1f505400000001010101010101010101010101010101773f803c7138824010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414b30332e32200a001d";
        };
        config = {
          eDP = {
            enable = true;
            mode = "1920x1080";
          };
          DisplayPort-3 = {
            enable = false;
          };
          DisplayPort-2 = {
            enable = false;
          };
          DisplayPort-5 = {
            enable = false;
          };
        };
        hooks.postswitch = {
          "configure_touch" =
            builtins.readFile ./configure_touch.sh;
        };
      };
      "default" = {
        fingerprint = {
          eDP =
            "00ffffffffffff0006af3d3200000000141c0104a51f117803f5658f555a932a1f505400000001010101010101010101010101010101773f803c7138824010103e0035ae100000180000000f0000000000000000000000000020000000fe0041554f0a202020202020202020000000fe004231343048414b30332e32200a001d";
        };
        config = {
          eDP = {
            enable = true;
            mode = "1920x1080";
          };
          DisplayPort-3 = {
            enable = false;
          };
          DisplayPort-2 = {
            enable = false;
          };
          DisplayPort-5 = {
            enable = false;
          };
        };
        hooks.postswitch = {
          "configure_touch" =
            builtins.readFile ./configure_touch.sh;
        };
      };
    };
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
