{ lib, pkgs, config, ... }:
with lib;
let cfg = config.luksab.var;
in {
  options.luksab.arch = lib.mkOption {
    type = lib.types.str;
    default = "x86_64";
    description = ''
      The system architecture
    '';
  };
}
