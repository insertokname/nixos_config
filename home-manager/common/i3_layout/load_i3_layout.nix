{ config, pkgs, ... }: {
  # Ain't porting all that to home manager
  home.file = {
    ".config/i3".source = ./i3;
    ".config/nitrogen".source = ./nitrogen;
    ".config/polybar".source = ./polybar;
  };
}
