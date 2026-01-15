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
    displayManager.sddm = {
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [
        where-is-my-sddm-theme
        kdePackages.qt5compat
      ];
      enable = true;
      wayland.enable = true;
      autoNumlock = true;
      theme = "where_is_my_sddm_theme";
      enableHidpi = true;
      settings = { General = { DisplayServer = "wayland"; }; };
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  security.polkit.enable = true;

  environment.systemPackages = with pkgs; [
    # sddm
    (where-is-my-sddm-theme.override {
      themeConfig.General.passwordCursorColor = "#FFFFFF";
    })

    # GNOME / Theming
    adwaita-icon-theme
    gnome-themes-extra
    gsettings-desktop-schemas
    adwaita-qt
    adwaita-qt6

    # Wayland / Sway
    wlr-randr
    wl-clipboard
    grim
    slurp
    mako
    wofi
    swaybg
    swaylock
    swayidle
    qt5.qtwayland
    qt6.qtwayland
    
    # Waybar and dependencies
    waybar
    playerctl
    pavucontrol
    networkmanagerapplet
    light
    wtype

    # X11 / General
    libva-utils
    xdg-desktop-portal
    xdg-desktop-portal-gtk
    qt6.qmake
  ];
}
