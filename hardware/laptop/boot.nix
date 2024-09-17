{ ... }: {
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    # theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
    efiSupport = true;
    devices = [ "nodev" ];
    useOSProber = true;
  };
  boot.loader.grub2-theme = {
    enable = true;
    theme = "vimix";
    footer = true;
    screen = "2k";
  };

}
