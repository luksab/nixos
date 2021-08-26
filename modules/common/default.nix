{ lib, config, pkgs, ... }:
with lib;
let cfg = config.luksab.common;

in {
  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  options.luksab.common = {
    enable = mkEnableOption "enable basics";
    disable-cache = mkEnableOption "not use binary-cache";
  };

  config = mkIf cfg.enable {
    luksab.zsh.enable = true;

    environment.systemPackages = with pkgs; [ git nixfmt ];

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

    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes ca-references
      '';

      # binary cache -> build by DroneCI
      binaryCachePublicKeys = mkIf (cfg.disable-cache != true)
        [ "cache.lounge.rocks:uXa8UuAEQoKFtU8Om/hq6d7U+HgcrduTVr8Cfl6JuaY=" ];
      binaryCaches = mkIf (cfg.disable-cache != true) [
        "https://cache.nixos.org"
        "https://cache.lounge.rocks?priority=50"
      ];
      trustedBinaryCaches = mkIf (cfg.disable-cache != true) [
        "https://cache.lounge.rocks"
        "https://cache.nixos.org"
      ];

      # Save space by hardlinking store files
      autoOptimiseStore = true;

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    system.stateVersion = "21.05";
  };
}
