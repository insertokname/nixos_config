{ ... }:
{
  flake.modules.homeManager.shell = {
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };
  };
}
