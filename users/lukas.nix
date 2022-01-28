{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukas = {
    isNormalUser = true;
    home = "/home/lukas";
    extraGroups = [ "wheel" "video" "networkmanager" "docker" "dialout" "usb" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:0826wzh9nmrjp256ixxyr6p2qch1vzx7d9zqmd95bm02k5vk8m00";
      })
    ];
  };

  nix.allowedUsers = [ "lukas" ];
}