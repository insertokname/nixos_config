# some sensible nix settings
{ inputs, ... }:
{
  flake.modules.nixos.base = { pkgs, ... }: {
    nix = {
      registry.nixpkgs.flake = inputs.nixpkgs;
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    environment.systemPackages = with pkgs; [
      nixfmt
      nixd
    ];
  };
}
