{ lib, config, ... }:
with lib;
let cfg = config.luksab.common;
in {
  imports = [ ../../users.nix ];

  options.luksab.common = { enable = mkEnableOption "enable basics"; };

  config = mkIf cfg.enable {
    home-manager.users.lukas = [
      ../../home-manager/home.nix
      { nixpkgs.overlays = [ self.overlay self.overlay-unstable ]; }
    ];
  };
}
