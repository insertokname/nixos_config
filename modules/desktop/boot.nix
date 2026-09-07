{ inputs, ... }: {
  flake.modules.nixos.desktop = { ... }: {
    imports = [
      inputs.grub2-themes.nixosModules.default
    ];
    boot.loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        configurationLimit = 10;
      };
      grub2-theme = {
        enable = true;
        theme = "vimix";
        footer = true;
        screen = "1080p";
        splashImage = ./background.png;
      };
      timeout = 3;
    };
  };
}
