{ ... }:
{
  flake.modules.homeManager.shell = {
    programs.alacritty = {
      enable = true;
      settings = {
        terminal.shell = "fish";
        window = {
          opacity = 0.9;
          blur = true;
        };
      };
    };
  };
}
