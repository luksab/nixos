{ self, ... }: {
  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  home-manager.users.lukas = {
    luksab.arch = "aarch64";
    imports = [
      ../../home-manager/home.nix
      {
        nixpkgs.overlays =
          [ self.overlay self.overlay-master self.overlay-stable ];
      }
    ];
  };

  luksab = {
    pi4b.enable = true;
    common.enable = true;
    desktop = { enable = true; };
    xrdp.enable = true;
  };

  networking = {
    hostName = "pi4b2";
    networkmanager = { enable = true; };
  };
}
