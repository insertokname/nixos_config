{ config, pkgs, lib, ... }: {
  home.file = { ".config/polybar".source = lib.mkForce ./polybar; };
}
