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
      exportConfiguration = true;
      enable = true;
      xkb = {
        layout = "us,ro";
        variant = ",std";
        options = "grp:alt_shift_toggle";
      };
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
        # defaultSession = "xfce+i3";
      };
      # displayManager.gdm = {
      #   enable = true;
      #   wayland = true;
      # };
      # displayManager.defaultSession = "wayland"
    };
    dbus.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  programs.hyprland = {
    enable = true;
    # nvidiaPatches = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    adwaita-icon-theme
    gnome-themes-extra
    gsettings-desktop-schemas
    wlr-randr
    wl-clipboard
    hyprland-protocols
    hyprpicker
    xdg-desktop-portal-hyprland
    hyprpaper
    wofi
    swww
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    qt5.qtwayland
    qt6.qmake
    qt6.qtwayland
    adwaita-qt
    adwaita-qt6
  ];
}
