{ config, pkgs,... }:
{
  hardware.opengl={
     enable = true;
     driSupport = true;
     driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  
  hardware.nvidia = {
     modesetting.enable = true;

     powerManagement.enable = false;
     powerManagement.finegrained = false;
     
     open = false;

     # Enable the Nvidia settings menu,
     # accessible via `nvidia-settings`.
     nvidiaSettings = true;

     package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}

