{ self, ... }: {
  flake.modules.nixos.desktop =
    { ... }:
    let
      gruvbox = self.lib.gruvbox;
    in
    {
      services.kmscon = {
        enable = true;

        useXkbConfig = true;

        config = {
          hwaccel = false;

          font-engine = "freetype";
          font-name = "monospace";
          font-size = 18;

          term = "xterm-256color";

          sb-size = 8192;

          palette = "custom";

          palette-background = gruvbox.rgb gruvbox.palette.background;
          palette-foreground = gruvbox.rgb gruvbox.palette.foreground;

          palette-black = gruvbox.rgb gruvbox.palette.normal.black;
          palette-red = gruvbox.rgb gruvbox.palette.normal.red;
          palette-green = gruvbox.rgb gruvbox.palette.normal.green;
          palette-yellow = gruvbox.rgb gruvbox.palette.normal.yellow;
          palette-blue = gruvbox.rgb gruvbox.palette.normal.blue;
          palette-magenta = gruvbox.rgb gruvbox.palette.normal.magenta;
          palette-cyan = gruvbox.rgb gruvbox.palette.normal.cyan;
          palette-light-grey = gruvbox.rgb gruvbox.palette.normal.white;

          palette-dark-grey = gruvbox.rgb gruvbox.palette.bright.black;
          palette-light-red = gruvbox.rgb gruvbox.palette.bright.red;
          palette-light-green = gruvbox.rgb gruvbox.palette.bright.green;
          palette-light-yellow = gruvbox.rgb gruvbox.palette.bright.yellow;
          palette-light-blue = gruvbox.rgb gruvbox.palette.bright.blue;
          palette-light-magenta = gruvbox.rgb gruvbox.palette.bright.magenta;
          palette-light-cyan = gruvbox.rgb gruvbox.palette.bright.cyan;
          palette-white = gruvbox.rgb gruvbox.palette.bright.white;
        };
      };
    };
}
