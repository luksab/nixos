{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:0826wzh9nmrjp256ixxyr6p2qch1vzx7d9zqmd95bm02k5vk8m00";
      })
    ];
  };
}
