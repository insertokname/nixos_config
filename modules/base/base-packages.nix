# dump of esential utils that idk where else to put
{ ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      firefox

      moonlight

      neovim
      git

      htop
      wget
    ];
  };
}
