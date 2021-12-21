{ self, ... }: {
  imports = [ ../../users/lukas.nix ../../users/root.nix ./nginx.nix ];
  networking.hostName = "arm";

  luksab = {
    qemu-guest.enable = true;
    openssh.enable = true;
    server.enable = true;

    lukas-bot.enable = true;

    minecraft-server = {
      enable = true;
      openFirewall = true;
    };

    overviewer = {
      enable = true;
      config = ''
        worlds["teddy"] = "/var/lib/minecraft-server/export"

        renders["Overworld"] = {
            "world": "teddy",
            'rendermode': 'smooth_lighting',
            "title": "Overworld",
            'crop': (-4000, -4000, 4000, 4000),
        }

        renders["night"] = {
            "world": "teddy",
            'rendermode': 'night',
            "title": "Night",
            'crop': (-1000, -500, 1000, 1500),
        }

        renders["nether"] = {
            "world": "teddy",
            "title": "Nether",
            "rendermode": nether_smooth_lighting,
            "dimension": "nether",
        }

        renders["end"] = {
            "world": "teddy",
            "title": "End",
            "rendermode": [Base(), EdgeLines(), SmoothLighting(strength=0.5)],
            "dimension": "end",
        }

        outputdir = "/var/www/overviewer"
      '';
    };
  };

  home-manager.users.lukas = {
    imports = [
      ../../home-manager/home-server.nix
      { nixpkgs.overlays = [ self.overlay self.overlay-master ]; }
    ];
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
    configurationLimit = 2;
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0E01-9111";
    fsType = "vfat";
  };
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "xfs";
  };
  systemd.units."dev-sda2.swap".enable = false;

  boot.cleanTmpDir = true;
  networking.interfaces.enp0s3.useDHCP = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 25565 ];
  networking.firewall.allowedUDPPorts = [ 19132 ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0rI0jOEIGoY3kQR5ErapABGPPCXv10OrBBTpniqOxdKc8d56f69/24LxmLTeSjo6VuME6Y4CcdEKl8PnVrp1kaAsqfMbjzzU/W7hGPUeTYutu69tgnWXc6g9Vf/oTzGgclY5TDZ1+QA9+wNiNdLxd2J9pzuVzyISHlO7sn8Vk+8rpV6r/MgCUYNVQvWDYi3jEu1Mp9YXn28rvG1pMuvn5hT28jZYC9A9TNFGtAb9BtVpRNWMDPMnlD6VdH8utBVb16yAD3DTY+Orb0TWjsrQQ7utMqrBulPyjD1//mTQhKggSww4lgn/sLzmi5xxgAGKFUn+N579bdlI4c7M+ZqWpHIJE3IXH2ux+iUjypcTBNgXpfS5neDVo08fE56QWLMcoqHOACi6p1jwK+6GaDSJpySwus2nj1vC7KXbSGZWJYCNSliuQOsqd/lXPt/q2qwADLl+2uy/jPy1iCYJrd8WsjZi98m2VSsGY+Z99a1GSZ3tEvqxn4IZQx9p1aizaDt0= lukas@desktop"
  ];
}

