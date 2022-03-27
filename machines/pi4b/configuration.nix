{ self, ... }: {
  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  home-manager.users.lukas = {
    luksab.arch = "aarch64";
    imports = [
      ../../home-manager/home-server.nix
      {
        nixpkgs.overlays =
          [ self.overlay self.overlay-master self.overlay-stable ];
      }
    ];
  };

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
