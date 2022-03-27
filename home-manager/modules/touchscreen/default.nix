{ lib, config, pkgs, fetchFromGitHub, ... }:
with lib; {
  home.packages = with pkgs; [ srandrd ];

  xsession.initExtra = ''
    ${pkgs.srandrd}/bin/srandrd xinput map-to-output 10 eDP-1
    xinput map-to-output 10 eDP-1
  '';
}
