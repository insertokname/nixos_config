{ ... }: {
  flake.modules.nixos.desktop = { ... }: {
    boot = {
      plymouth.enable = true;

      # Enable "Silent Boot"
      consoleLogLevel = 0;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=0"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=0"
        "udev.log_priority=0"
      ];
    };
  };
}
