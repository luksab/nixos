{ self, ... }: {
  imports = [ ../../users/lukas.nix ../../users/root.nix ];
  networking.hostName = "nix86";

  luksab = {
    qemu-guest.enable = true;
    openssh.enable = true;
    server.enable = true;
  };

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1F17-62E7";
    fsType = "vfat";
  };
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = {
    device = "/dev/sda3";
    fsType = "xfs";
  };

  boot.cleanTmpDir = true;
  networking.interfaces.ens3.useDHCP = true;
  networking.firewall.allowPing = true;
  networking.firewall.allowedTCPPorts = [ 22 80 443 25565 5201 ];
  networking.firewall.allowedUDPPorts = [ 19132 5201 ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0rI0jOEIGoY3kQR5ErapABGPPCXv10OrBBTpniqOxdKc8d56f69/24LxmLTeSjo6VuME6Y4CcdEKl8PnVrp1kaAsqfMbjzzU/W7hGPUeTYutu69tgnWXc6g9Vf/oTzGgclY5TDZ1+QA9+wNiNdLxd2J9pzuVzyISHlO7sn8Vk+8rpV6r/MgCUYNVQvWDYi3jEu1Mp9YXn28rvG1pMuvn5hT28jZYC9A9TNFGtAb9BtVpRNWMDPMnlD6VdH8utBVb16yAD3DTY+Orb0TWjsrQQ7utMqrBulPyjD1//mTQhKggSww4lgn/sLzmi5xxgAGKFUn+N579bdlI4c7M+ZqWpHIJE3IXH2ux+iUjypcTBNgXpfS5neDVo08fE56QWLMcoqHOACi6p1jwK+6GaDSJpySwus2nj1vC7KXbSGZWJYCNSliuQOsqd/lXPt/q2qwADLl+2uy/jPy1iCYJrd8WsjZi98m2VSsGY+Z99a1GSZ3tEvqxn4IZQx9p1aizaDt0= lukas@desktop"
  ];

  services.nginx = {
    enable = true;
    recommendedOptimisation = true;
  };
  services.nginx.virtualHosts."x86.luksab.de" = {
    addSSL = true;
    enableACME = true;
    root = "/var/www/x86.luksab.de";
    locations = { "/" = { extraConfig = "access_log off;"; }; };
  };
  security.acme.acceptTerms = true;
  security.acme.certs = {
    "x86.luksab.de".email = "lukassabatschus@gmail.com";
  };
}

