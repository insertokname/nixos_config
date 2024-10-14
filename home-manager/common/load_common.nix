{ config, pkgs, ... }: {
  imports = [
    ./alacritty.nix
    ./fish.nix
    ./i3_layout/load_i3_layout.nix
    ./vs_code.nix
    ./zoxide.nix
    ./thefuck.nix
  ];
}
