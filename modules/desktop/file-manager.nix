{ ... }: {
  flake.modules.nixos.desktop = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      nemo-with-extensions
    ];

    services.gvfs.enable = true;
    services.tumbler.enable = true;
  };
}
