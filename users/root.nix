{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:0f8n61yr6kyiz5bb39kbl4r0d03ynjab535b6nq8zcqfaq0gav74";
      })
    ];
  };
}
