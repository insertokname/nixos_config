# dump of esential utils that idk where else to put
{ ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      neovim
      claude-code
      htop
      git
      gh
      vscode
      firefox
    ];
  };
}
