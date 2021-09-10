{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:1igzydnqfn35y3xd49acdir98d3mprkcxrbzyrsmrp3j781dy33c";
      })
    ];
  };
}
