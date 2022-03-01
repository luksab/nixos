{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.nameserver;
in {

  options.luksab.nameserver = { enable = mkEnableOption "use nameserver"; };

  config = mkIf cfg.enable {
    # Generate an immutable /etc/resolv.conf from the nameserver settings
    # above (otherwise DHCP overwrites it):
    environment.etc."resolv.conf" = with lib;
      with pkgs; {
        source = writeText "resolv.conf" ''
          ${concatStringsSep "\n"
          (map (ns: "nameserver ${ns}") config.networking.nameservers)}
          options edns0
        '';
      };
    networking.nameservers = [ "10.31.69.1" "1.1.1.1" ];
  };
}
