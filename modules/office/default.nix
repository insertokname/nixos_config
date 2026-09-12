{ ... }: {
  flake.modules.nixos.office = { pkgs-stable, ... }: {
    environment.systemPackages = [
      pkgs-stable.onlyoffice-desktopeditors
    ];
  };
}
