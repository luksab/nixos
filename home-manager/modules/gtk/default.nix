{ config, pkgs, lib, ... }: {
  # GTK settings
  gtk = {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "materia-theme";
      package = pkgs.materia-theme;
    };
  };

  home.sessionVariables.GTK_THEME = "materia-theme";
}
