{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lukas = {
    isNormalUser = true;
    home = "/home/lukas";
    extraGroups = [ "wheel" "video" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:0f8n61yr6kyiz5bb39kbl4r0d03ynjab535b6nq8zcqfaq0gav74";
      })
    ];
  };

  nix.allowedUsers = [ "lukas" ];
}