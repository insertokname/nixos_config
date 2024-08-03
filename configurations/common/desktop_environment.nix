{ pkgs, ... }: {
  services = {
    illum.enable = true;
    picom = {
      backend = "glx";
      enable = true;
      opacityRules = [ "87:class_g = 'Alacritty'" ];
      settings = {
        blur = {
          method = "dual_kawase";
          strength = 6;
        };
      };
    };
    xserver = {
      layout = "us";
      xkbVariant = "";
      enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [ ];
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
        };
      };
      displayManager = {
        lightdm.enable = true;
        defaultSession = "xfce+i3";
      };
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };
}
