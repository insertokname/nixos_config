{ config, pkgs, lib, ... }: {
  programs.alacritty.settings.font.size = lib.mkForce 15;

  home.file = { ".config/polybar".source = lib.mkForce ./polybar; };
}
