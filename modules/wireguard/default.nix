{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.wireguard;
in {

  options.luksab.wireguard = {
    enable = mkEnableOption "activate wireguard";
    ip = mkOption {
      type = types.str;
      example = "10.31.69.101/24";
      description = "own ip";
    };
    allowedIPs = mkOption {
      type = types.listOf types.str;
      default =
        [ "10.31.69.0/24" "185.163.117.233" "90.130.70.73" "152.70.53.164" ];
      description = "ips to tunnel";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 51820 ];
    networking.wireguard.interfaces.wg0 = {
      listenPort = 51820;
      ips = [ cfg.ip ];
      # Path to the private key file
      privateKeyFile = toString /var/src/secrets/wireguard/private;
      generatePrivateKeyFile = true;

      peers = [{
        publicKey = "ZxfxvKgR9xXdYwwKQdkURq7k5NEK2AypLEPM8jVnwlg=";
        allowedIPs = cfg.allowedIPs;
        endpoint = "nc.luksab.de:51820";
        persistentKeepalive = 15;
      }];
    };
  };
}
