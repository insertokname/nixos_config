{ ... }: {
  flake.modules.nixos.gotgaymsonyophone = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.steam
    ];
  };
}
