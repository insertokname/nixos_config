#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash stow findutils

#this script is responsable for building the dotfiles for the correct user
#cleaning up any old dotfiles that were created in the past by this program
#and finally making a symlink between the formated dotfiles and the .config using GNU stow

set -euo pipefail

cd ./dotfiles

case $1 in
  ferenti)
    nix-build dotfiles.nix --argstr replacements \
    "VARS_POLYBAR_DISPLAY_PORT eDP
    VARS_POLYBAR_FONT_SIZE_0 15
    VARS_POLYBAR_FONT_SIZE_1 16"
    
    ;;

  fekete)
    nix-build dotfiles.nix --argstr replacements \
    "VARS_POLYBAR_DISPLAY_PORT DP-0
    VARS_POLYBAR_FONT_SIZE_0 11
    VARS_POLYBAR_FONT_SIZE_1 12"
    ;;

  *)
    echo "Unknown profile name '$1'"
    exit 1;
    ;;
esac

find $HOME/.config -lname "*insertokname-dotfiles-management*" -delete

cd ./result
stow -D -t $HOME/.config .
stow -t $HOME/.config .