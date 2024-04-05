{replacements?""}:
let
  pkgs = import <nixpkgs> {};
in

  pkgs.stdenv.mkDerivation {
    name = "insertokname-dotfiles-management";
    system = "x86_64-linux";
    
    builder = ["${pkgs.bash/bin/bash}"];

    inherit (pkgs) coreutils gnused gnugrep findutils;
    inherit replacements;
    original = ./dotfiles;
    replace_script = ./replace_strings.sh;

    args = ["-c" ''
                  $replace_script
                 ''
    ];
    
}