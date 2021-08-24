{ lib, modulesPath, config, ... }:
with lib;
let cfg = config.luksab.firmware;
in {
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  options.luksab.qemu-guest = {
    enable = mkEnableOption "enable qemu guest firmware";
  };

  config = mkIf cfg.enable {
    services.qemuGuest.enable = true;
    # disable swap
    swapDevices = lib.mkForce [ ];
  };
}
