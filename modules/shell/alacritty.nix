{ self, ... }:
{
  flake.modules.homeManager.shell =
    { ... }:
    let
      gruvbox = self.lib.gruvbox;
    in
    {
      programs.alacritty = {
        enable = true;
        settings = {
          terminal.shell = "fish";
          window = {
            opacity = 0.9;
            blur = true;
          };

          colors = {
            primary = {
              background = gruvbox.hex gruvbox.palette.background;
              foreground = gruvbox.hex gruvbox.palette.foreground;
            };
            normal = builtins.mapAttrs (_: gruvbox.hex) gruvbox.palette.normal;
            bright = builtins.mapAttrs (_: gruvbox.hex) gruvbox.palette.bright;
          };
        };
      };
    };
}
