{ config, pkgs, lib, ... }: {
  home.file = { ".config/polybar".source = lib.mkForce ./polybar; };
  imports = [ ./alacritty.nix ];
}
