{ config, pkgs, ... }: {
  imports = [
    ./alacritty.nix
    # ./fish.nix
    ./i3_layout/load_i3_layout.nix
  ];

  programs.fish.enable = true;

  # home.file = {
  #     ".config/fish".source = ./fish;
  # };
}
