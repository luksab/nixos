{ lib, config, pkgs, ... }: {
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
  networking.nameservers = [ "2001:4860:4860::8888" "1.1.1.1" ];
}
