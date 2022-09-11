{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.wireguard;
in {

  options.luksab.wireguard = {
    enable = mkEnableOption "activate wireguard";
    ips = mkOption {
      type = types.listOf types.str;
      example = [ "10.31.69.101/24" "2a03:4000:1c:6c3::5e1f:de53/64" ];
      description = "own ip";
    };
    allowedIPs = mkOption {
      type = types.listOf types.str;
      default = [ "10.31.69.0/24" "2a03:4000:1c:6c3::/64" ];
      description = "ips to tunnel";
    };
    server = mkOption {
      type = types.str;
      default = "185.194.142.8:51820";
      description = "Server to connect to";
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [ 51820 ];
    networking.wg-quick.interfaces.wg0 = {
      listenPort = 51820;
      address = cfg.ips;
      # Path to the private key file
      privateKeyFile = "/var/secrets/wireguard/private";
      # `mkdir -p /var/secrets/wireguard`
      # execute `wg genkey  > /var/secrets/wireguard/private` on first enable
      # `chmod 600 /var/secrets/wireguard/private`
      # `chown root:root /var/secrets/wireguard/private`

      peers = [{
        publicKey = "ZxfxvKgR9xXdYwwKQdkURq7k5NEK2AypLEPM8jVnwlg=";
        allowedIPs = cfg.allowedIPs;
        endpoint = cfg.server;
        persistentKeepalive = 15;
      }];
    };
  };
}
