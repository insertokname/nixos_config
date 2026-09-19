{ ... }: {
  flake.modules.nixos.office = { pkgs-stable, pkgs, ... }: {
    environment.systemPackages = [
      pkgs-stable.onlyoffice-desktopeditors
      pkgs.obs-studio
    ];
  };
}
