{ self, nixos-hardware, ... }: {
  luksab = {
    pi4b.enable = true;
    common.enable = true;
    wireguard = {
      enable = true;
      ips = [ "10.31.69.5/24" ];
    };
  };

  networking = {
    hostName = "pi4b";
    networkmanager = { enable = true; };
  };
}
