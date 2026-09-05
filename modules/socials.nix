{ ... }:
{
  flake.modules.nixos.socials = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      signal-desktop
      vesktop
    ];
  };
}
