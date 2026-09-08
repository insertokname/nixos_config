{ ... }:
{
  flake.modules.homeManager.desktop =
    { ... }:
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };
    };
}
