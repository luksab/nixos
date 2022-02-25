{ config, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix> ];
  environment.systemPackages = [ pkgs.git ];
  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    # binary cache -> build by DroneCI
    binaryCachePublicKeys =
      [ "cache.lounge.rocks:uXa8UuAEQoKFtU8Om/hq6d7U+HgcrduTVr8Cfl6JuaY=" ];
    binaryCaches =
      [ "https://cache.nixos.org" "https://cache.lounge.rocks?priority=50" ];
    trustedBinaryCaches =
      [ "https://cache.lounge.rocks" "https://cache.nixos.org" ];
  };

}
