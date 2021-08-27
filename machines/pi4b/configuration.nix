{ self, ... }: {

  luksab = {
    pi4b.enable = true;
    common.enable = true;
    server = {
      enable = true;
      homeConfig = {
        imports = [
          ../../home-manager/home-server.nix
          { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
        ];
      };
    };
  };

  networking = {
    hostName = "pi4b";
    networkmanager = { enable = true; };
  };
}
