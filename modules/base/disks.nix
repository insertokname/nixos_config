{ ... }: {
  flake.modules.nixos.base = { ... }: {
    services.udisks2.enable = true;
    services.gvfs.enable = true;
  };
}
