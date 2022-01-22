{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.nginx;
in {
  options.luksab.nginx = {
    enable = mkEnableOption "activate nginx";
    email = mkOption {
      type = types.str;
      default = "lukassabatschus@gmail.com";
      description = ''
        acme Email address
      '';
    };
  };

  config = mkIf cfg.enable {

    security.acme.defaults.email = "${cfg.email}";
    security.acme.acceptTerms = true;

    services.nginx = {
      enable = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
      clientMaxBodySize = "128m";

      commonHttpConfig = ''
        server_names_hash_bucket_size 128;
      '';
    };

  };
}
