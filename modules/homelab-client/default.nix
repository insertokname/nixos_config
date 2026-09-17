{ ... }:
{
  flake.modules.nixos.homelab-client = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      moonlight
      openssh
    ];
  };
}
