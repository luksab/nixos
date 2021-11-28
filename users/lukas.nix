{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukas = {
    isNormalUser = true;
    home = "/home/lukas";
    extraGroups = [ "wheel" "video" "networkmanager" "docker" "dialout" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:14n4lfw94w7pl0qp70c2ajdzfd7dv35fskspay6kmbp42b3s6wvf";
      })
    ];
  };

  nix.allowedUsers = [ "lukas" ];
}