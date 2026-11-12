{ pkgs, config, ... }:

{
  qt = {
    enable = true;
    platformTheme.name = "qtct";

    qt6ctSettings = {
      Appearance = {
        style = "Fusion";
        custom_palette = true;
        color_scheme_path = "${config.home.homeDirectory}/.config/qt6ct/colors/noctalia.conf";
        icon_theme = "Papirus-Dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk4.theme = null;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "black"; };
    };
  };

  dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  gtk.gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
  gtk.gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
}
