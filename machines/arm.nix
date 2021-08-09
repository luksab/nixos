{ modulesPath, lib, ... }:{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };
  fileSystems."/boot" = { device = "/dev/disk/by-uuid/0E01-9111"; fsType = "vfat"; };
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda3"; fsType = "xfs"; };
  systemd.units."dev-sda2.swap".enable = false;
  swapDevices = lib.mkForce [ ];

  boot.cleanTmpDir = true;
  networking.hostName = "nixostest";
  networking.interfaces.enp0s3.useDHCP = true;
  #  address = "158.101.213.105";
  #  prefixLength = 24;
  #} ];
  networking.firewall.allowPing = true;
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD0rI0jOEIGoY3kQR5ErapABGPPCXv10OrBBTpniqOxdKc8d56f69/24LxmLTeSjo6VuME6Y4CcdEKl8PnVrp1kaAsqfMbjzzU/W7hGPUeTYutu69tgnWXc6g9Vf/oTzGgclY5TDZ1+QA9+wNiNdLxd2J9pzuVzyISHlO7sn8Vk+8rpV6r/MgCUYNVQvWDYi3jEu1Mp9YXn28rvG1pMuvn5hT28jZYC9A9TNFGtAb9BtVpRNWMDPMnlD6VdH8utBVb16yAD3DTY+Orb0TWjsrQQ7utMqrBulPyjD1//mTQhKggSww4lgn/sLzmi5xxgAGKFUn+N579bdlI4c7M+ZqWpHIJE3IXH2ux+iUjypcTBNgXpfS5neDVo08fE56QWLMcoqHOACi6p1jwK+6GaDSJpySwus2nj1vC7KXbSGZWJYCNSliuQOsqd/lXPt/q2qwADLl+2uy/jPy1iCYJrd8WsjZi98m2VSsGY+Z99a1GSZ3tEvqxn4IZQx9p1aizaDt0= lukas@desktop" 
  ];
}

