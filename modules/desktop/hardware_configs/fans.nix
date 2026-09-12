{ ... }:
{
  flake.modules.nixos.desktop =
    { config, ... }:
    {
      programs.coolercontrol.enable = true;
      boot.extraModulePackages = [ config.boot.kernelPackages.nct6687d ];
      boot.kernelModules = [ "nct6687" ];
      boot.blacklistedKernelModules = [ "nct6683" ];
    };
}
