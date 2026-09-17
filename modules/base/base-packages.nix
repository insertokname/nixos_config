# dump of esential utils that idk where else to put
{ ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      htop
      wget
      openssl
      unzip
      zip

      git
      neovim

      firefox
    ];

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
