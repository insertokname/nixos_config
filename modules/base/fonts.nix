{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts = {
        enableDefaultPackages = true;

        packages = with pkgs; [
          nerd-fonts.symbols-only
          nerd-fonts.caskaydia-cove
          nerd-fonts.caskaydia-mono
          ubuntu-sans
          source-serif
          noto-fonts-color-emoji
        ];

        fontconfig = {
          defaultFonts = {
            sansSerif = [ "Ubuntu Sans" ];
            serif = [ "Source Serif 4" ];
            monospace = [ "CaskaydiaCove Nerd Font Mono" ];
            emoji = [ "Noto Color Emoji" ];
          };

          subpixel.rgba = "rgb";
 
          useEmbeddedBitmaps = true;
        };
      };

      programs.dconf.enable = true;
    };

  flake.modules.homeManager.base = { ... }: {
    dconf.settings."org/gnome/desktop/interface" = {
      font-name = "Ubuntu Sans 11";
      document-font-name = "Sans 11";
      monospace-font-name = "CaskaydiaCove Nerd Font Mono Semibold";
    };
  };
}
