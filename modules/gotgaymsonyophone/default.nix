{ ... }: {
  flake.modules.nixos.gotgaymsonyophone = { pkgs, ... }: {
    environment.systemPackages = [
      pkgs.heroic
    ];

    programs.steam = {
      enable = true;
    };
  };
}
