{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:06l3dqlh6z8y0y6nzkm3wlnxabjkb62m12piyb98cx5avnmasypb";
      })
    ];
  };
}
