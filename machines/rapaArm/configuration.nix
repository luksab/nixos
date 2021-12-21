{ self, ... }: {
  imports = [ ../../users/lukas.nix ../../users/root.nix ./minecraft.nix ];
  networking.hostName = "rapaArm";

  luksab = {
    qemu-guest.enable = true;
    openssh.enable = true;
    server.enable = true;
    wireguard = {
      enable = true;
      ip = "10.31.69.207/24";
      allowedIPs = [ "10.31.69.0/24" "185.163.117.233" "90.130.70.73" "91.65.93.7" "152.70.53.164" ];
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
    device = "/dev/disk/by-uuid/6129-FC42";
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
  #  address = "158.101.213.105";
  #  prefixLength = 24;
  #} ];
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 25565 ];
  networking.firewall.allowedUDPPorts = [ 24454 19132 ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDmioxcsRY28SODmEq+x4F283PhBD5pnfEEYVabMASIzG10QUDVlXfcXGQrWj/TNldhSviWx7VXjZGCi4bZYIfvPOlk3Lo467UAsQb4rJWEJJDeMwm9AWkbMFqtXOJAezGCWXp6cSQ6U7hqwd7JFtI3My1Z1/bqor/gavIYVJrpnakyHq3QZ/U936CS5hn84QhS3UzfUUo38D5HKipa7Y7uLMW3jOIF7OTgjjVfS4CnywcU7vA1zTRi/EOHd+3vGshMqLkp40BzKoMfv2Lla7ust/G+942FwH83lm+g0bW6gLd7R3Mkjj2M1ESnJl5PTqPk3dDO+HBXFLYBgTOIPTcz5KtB50BiGJqQ0lhfMAQOCvb+prVSBzfGvdWFq0ElIHJpHgWEvKkfRdz7cZdjeilRggBAYUPxDUOEnWN/xQ3tjXNM44G/oLmWgnLpo87p5dfyS7P+fMZbCaYN3P2VQysgWh6MHWaxbBgcp5edYxWzHcyg1HFq6WvrWCWOMjFpUp6rtY/e0UM4aAHX4mVYLFHrESGWzZ/cy47hji9z0HjJTGa1bLPU63wn1tRSqHSCtDJQY44uKCYgvxkqiMRSMXCI3O6JWRNdb+Ectf+xAnabvATEizy+S5G9QOB0r1570ttFx4o3QlA0OxOXFTmKX7v+WqoImLXTwateFzNqn1F32w== cardno:000617113149"
  ];

  #  services.nginx.enable = true;
  #  services.nginx.virtualHosts."ocp.luksab.de" = {
  #    forceSSL = true;
  #    enableACME = true;
  #    #root = "/home/lukas/mcmap";
  #    root = "/var/www/overviewer";
  #  };
  #  security.acme.acceptTerms = true;
  #  security.acme.certs = {
  #    "ocp.luksab.de".email = "lukassabatschus@gmail.com";
  #  };
  # Enable cron service
  # services.cron = {
  #   enable = true;
  #   systemCronJobs = [
  #     "0 * * * *      root    . /etc/profile; /home/lukas/teddy/overviewer/render.sh  >> /tmp/cron.log"
  #   ];
  # };
}

