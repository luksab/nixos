{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:14n4lfw94w7pl0qp70c2ajdzfd7dv35fskspay6kmbp42b3s6wvf";
      })
    ];
  };
}
