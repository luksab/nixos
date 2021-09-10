{ config, pkgs, lib, ... }: {
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    openssh.authorizedKeys.keyFiles = [
      (builtins.fetchurl {
        url = "https://github.com/luksab.keys";
        sha256 = "sha256:03i5mg0h1c2j58fpk293s0mikhnk1968gc9gjq1c2hwkq1af493y";
      })
    ];
  };
}
