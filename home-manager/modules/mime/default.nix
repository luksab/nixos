{ lib, config, pkgs, fetchFromGitHub, ... }:
with lib;

let cfg = config.luksab.mime;

in {
  options.luksab.mime = { enable = mkEnableOption "enable mime handling"; };

  config = mkIf cfg.enable {
    xdg.mimeApps = {
        enable = true;
        defaultApplications = {
            "application/x-zip"= [ "org.gnome.FileRoller.desktop" ];
            "application/zip"= [ "org.gnome.FileRoller.desktop" ];
            "image/png" = [ "feh.desktop" ];
            "image/jpeg" = [ "feh.desktop" ];
            "x-scheme-handler/http=" = [ "brave-browser.desktop" ];
            "x-scheme-handler/https=" = [ "brave-browser.desktop" ];
            "x-scheme-handler/chrome" = [ "brave-browser.desktop" ];
            "text/html" = [ "brave-browser.desktop" ];
            # echo $XDG_DATA_DIRS
            /*text/html=brave-browser.desktop
            x-scheme-handler/http=brave-browser.desktop
            x-scheme-handler/https=brave-browser.desktop
            x-scheme-handler/about=brave-browser.desktop
            x-scheme-handler/unknown=brave-browser.desktop
            x-scheme-handler/chrome=userapp-Firefox-AZQ280.desktop
            application/x-extension-htm=userapp-Firefox-AZQ280.desktop
            application/x-extension-html=userapp-Firefox-AZQ280.desktop
            application/x-extension-shtml=userapp-Firefox-AZQ280.desktop
            application/xhtml+xml=userapp-Firefox-AZQ280.desktop
            application/x-extension-xhtml=userapp-Firefox-AZQ280.desktop
            application/x-extension-xht=userapp-Firefox-AZQ280.desktop
            x-scheme-handler/mailto=brave-browser.desktop
            application/zip=org.gnome.FileRoller.desktop
            application/x-zip=org.gnome.FileRoller.desktop*/
            /*[Added Associations]
            x-scheme-handler/http=userapp-Firefox-AZQ280.desktop;
            x-scheme-handler/https=userapp-Firefox-AZQ280.desktop;
            x-scheme-handler/chrome=userapp-Firefox-AZQ280.desktop;
            text/html=userapp-Firefox-AZQ280.desktop;
            application/x-extension-htm=userapp-Firefox-AZQ280.desktop;
            application/x-extension-html=userapp-Firefox-AZQ280.desktop;
            application/x-extension-shtml=userapp-Firefox-AZQ280.desktop;
            application/xhtml+xml=userapp-Firefox-AZQ280.desktop;
            application/x-extension-xhtml=userapp-Firefox-AZQ280.desktop;
            application/x-extension-xht=userapp-Firefox-AZQ280.desktop;
            application/x-shellscript=nautilus-autorun-software.desktop;
            */
        };
    };
  };
}
