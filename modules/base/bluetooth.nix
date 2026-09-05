{ ... }:
{
  flake.modules.nixos.base = { ... }: {
    services.blueman.enable = true;
    hardware = {
      bluetooth.enable = true;
    };
  };
}
