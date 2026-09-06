{ ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, config, ... }:
    let
      gruvbox = pkgs.gruvbox-gtk-theme.override {
        colorVariants = [ "dark" ];
        themeVariants = [ "default" ];
        sizeVariants = [ "standard" ];
        tweakVariants = [ ];
      };
    in
    {
      gtk = {
        enable = true;

        theme = {
          name = "Gruvbox-Dark";
          package = gruvbox;
        };

        gtk4.theme = config.gtk.theme;

        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs.gruvbox-plus-icons;
        };

        colorScheme = "dark";
      };

      dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
}
