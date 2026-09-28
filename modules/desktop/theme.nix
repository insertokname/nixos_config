{ ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, config, ... }:
    {
      gtk = {
        enable = true;

        theme = {
          name = "Gruvbox-Dark";
          package = pkgs.gruvbox-gtk-theme.override {
            colorVariants = [ "dark" ];
            themeVariants = [ "default" ];
            sizeVariants = [ "standard" ];
            tweakVariants = [ ];
          };
        };

        gtk4.theme = config.gtk.theme;

        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs.gruvbox-plus-icons;
        };

        font = {
          name = "Ubuntu Sans";
          size = 11;
        };

        colorScheme = "dark";
      };

      qt = {
        enable = true;
        platformTheme.name = "qtct";
        style.name = "kvantum";

        kvantum = {
          enable = true;
          themes = [ pkgs.gruvbox-kvantum ];
          settings.General.theme = "Gruvbox-Dark-Brown";
        };

        qt5ctSettings = {
          Appearance = {
            style = "kvantum";
            icon_theme = config.gtk.iconTheme.name;
            standard_dialogs = "xdgdesktopportal";
          };
          Fonts = {
            general = ''"${config.gtk.font.name},${toString config.gtk.font.size}"'';
            fixed = ''"CaskaydiaCove Nerd Font Mono,${toString config.gtk.font.size}"'';
          };
        };
        qt6ctSettings = config.qt.qt5ctSettings;
      };

      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
}
