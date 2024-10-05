{ ... }: {

  services.xserver.displayManager.sessionCommands =
    "xrandr --output eDP --mode 1920x1200";

  boot.loader = {
    efi.canTouchEfiVariables = true;
    grub2-theme = {
      enable = true;
      theme = "vimix";
      footer = true;
      screen = "2k";
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
