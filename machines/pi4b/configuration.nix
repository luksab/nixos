{ self, ... }: {
  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  home-manager.users.lukas = {
    luksab.arch = "aarch64";
    imports = [
      ../../home-manager/home-server.nix
      { nixpkgs.overlays = [ self.overlay self.overlay-unstable self.overlay-master ]; }
    ];
  };

  luksab = {
    pi4b.enable = true;
    common.enable = true;
  };

  networking = {
    hostName = "pi4b";
    networkmanager = { enable = true; };
  };
}
