{ lib, config, pkgs, inputs, ... }:
with lib;
let cfg = config.luksab.common;

in {
  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  options.luksab.common = {
    enable = mkEnableOption "enable basics";
    disable-cache = mkEnableOption "not use binary-cache";
  };

  config = mkIf cfg.enable {
    luksab = {
      openssh.enable = true;
      zsh.enable = true;
      wg_hosts.enable = true;
    };

    mayniklas.var.mainUser = "lukas";

    environment.systemPackages = with pkgs; [ git nixfmt usbutils pciutils config.boot.kernelPackages.perf ];

    programs.mtr.enable = true;

    # Allow unfree at system level
    nixpkgs.config.allowUnfree = true;

    # Set your time zone.
    time.timeZone = "Europe/Amsterdam";

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    networking.useDHCP = false;

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";
    console = {
      font = "Lat2-Terminus16";
      useXkbConfig = true;
    };

    services.journald.extraConfig = ''
      SystemMaxUse=1G
    '';

    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';

      settings = {
        # binary cache -> build by DroneCI
        trusted-public-keys = mkIf (cfg.disable-cache != true)
          [ "cache.lounge.rocks:uXa8UuAEQoKFtU8Om/hq6d7U+HgcrduTVr8Cfl6JuaY=" ];
        substituters = mkIf (cfg.disable-cache != true) [
          "https://cache.nixos.org"
          "https://cache.lounge.rocks?priority=100"
          "https://s3.lounge.rocks/nix-cache?priority=50"
        ];
        trusted-substituters = mkIf (cfg.disable-cache != true) [
          "https://cache.lounge.rocks"
          "https://cache.nixos.org"
          "https://s3.lounge.rocks/nix-cache/"
        ];

        # Save space by hardlinking store files
        auto-optimise-store = true;
      };

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    environment.etc."nix/flake_inputs.prom" = {
      mode = "0555";
      text = ''
        # HELP flake_registry_last_modified Last modification date of flake input in unixtime
        # TYPE flake_input_last_modified gauge
        ${concatStringsSep "\n" (map (i:
          ''
            flake_input_last_modified{input="${i}",${
              concatStringsSep "," (mapAttrsToList (n: v: ''${n}="${v}"'')
                (filterAttrs (n: v: (builtins.typeOf v) == "string")
                  inputs."${i}"))
            }} ${toString inputs."${i}".lastModified}'') (attrNames inputs))}
      '';
    };

    system.stateVersion = "21.11";
  };
}
