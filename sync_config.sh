#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash stow findutils

#this script is responsable for building the dotfiles for the correct user
#cleaning up any old dotfiles that were created in the past by this program
#and finally making a symlink between the formated dotfiles and the .config using GNU stow

set -euo pipefail

cd ./dotfiles

case $1 in
  ferenti)
    nix-build dotfiles.nix --argstr replacements "VARS_DISPLAY_PORT eDP"
    ;;

  fekete)
    nix-build dotfiles.nix --argstr replacements "VARS_DISPLAY_PORT DP-0"
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