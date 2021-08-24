{ lib, config, pkgs, ... }:
with lib;
let cfg = config.luksab.common;
in {
  imports = [ ../../users/lukas.nix ../../users/root.nix ];

  options.luksab.common = { enable = mkEnableOption "enable basics"; };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ git ];

    programs.mtr.enable = true;
    
    # Configure keymap in X11
    services.xserver.layout = "de";
    services.xserver.xkbOptions = "eurosign:e,caps:swapescape";

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

      # Save space by hardlinking store files
      autoOptimiseStore = true;

      # Clean up old generations after 30 days
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 30d";
      };
    };

    programs.fish.enable = true;

    system.stateVersion = "21.05";
  };
}
