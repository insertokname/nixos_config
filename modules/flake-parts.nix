{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-parts.flakeModules.modules
  ];

  options.flake.lib = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = { };
    description = "some util functions used in the config";
  };
}
