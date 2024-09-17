{ ... }: {
  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub2-theme = {
      enable = true;
      theme = "vimix";
      footer = true;
      screen = "1080p";
      splashImage = ../../backgrounds/background.png;
    };
    grub = {
      enable = true;
      # theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
      efiSupport = true;
      devices = [ "nodev" ];
      useOSProber = true;
    };
    timeout = 10;
  };
}

