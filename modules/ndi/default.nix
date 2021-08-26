{ lib, config, ... }:
with lib;
let cfg = config.luksab.ndi;
in {
  options.luksab.ndi = { enable = mkEnableOption "Allow ndi to work"; };

  config = mkIf cfg.enable {
    # enable NDI to communicate
    services.avahi.enable = true;
    #TODO: which of these do I actually need?
    networking.firewall.allowedTCPPorts = [ 22 5990 5353 5961 ];
    networking.firewall.allowedUDPPorts = [ 5990 5353 5961 ];

    networking.firewall.allowedTCPPortRanges = [ { from = 49152; to = 65535; } ];
    networking.firewall.allowedUDPPortRanges = [ { from = 49152; to = 65535; } ];
  };
}
