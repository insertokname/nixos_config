{ ... }:
{
  flake.modules.nixos.shell = { pkgs, ... }: {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
  };

  flake.modules.homeManager.shell = {
    programs.fish = {
      enable = true;
      functions = {
        fish_greeting = {
          body = "";
        };
      };
      shellAliases = {
        gr = "git pull --rebase";
        gf = "git fetch";
        gs = "git status";
        ga = "git add .";
        gc = "git commit -m";
        gp = "git push";
      };
    };
  };
}
