# dump of esential utils that idk where else to put
{ ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      gdu
      htop
      btop
      wget
      openssl
      rar
      zip
      unzip
      unrar

      git
      neovim

      firefox
      qbittorrent
    ];

    environment.variables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
