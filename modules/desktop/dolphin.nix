{ ... }: {
  flake.modules.nixos.desktop = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      kdePackages.qtsvg
      kdePackages.dolphin
    ];
  };
}
