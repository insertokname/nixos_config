{ config, pkgs, newest_pkgs, ... }: {
  imports = [ ./desktop_environment.nix ./boot.nix ];

  # linux driver
  boot.kernelPackages = pkgs.linuxPackages_latest;

  programs.adb.enable = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 3000 5500 ];
      allowedUDPPorts = [ 3000 5500 ];
    };
    hostName = "nixos-default";
    networkmanager.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
    LC_CTYPE = "en_US.utf8"; # required by dmenu don't change this
  };

  # sound.enable = true;
  time.hardwareClockInLocalTime = true;
  time.timeZone = "Europe/Bucharest";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  xdg.sounds.enable = false;

  #docker daemon
  virtualisation.docker.enable = true;

  virtualisation.vmware.host.enable = true;
  virtualisation.vmware.guest.enable = true;

  environment.systemPackages = with pkgs;
    [
      pinta
      #pgadmin4
      mariadb
      mysql-workbench
      distrobox
      docker-compose
      nixfmt-classic
      home-manager
      vesktop
      dmenu
      git
      gnome-keyring
      nerdfonts
      networkmanagerapplet
      nitrogen
      pasystray
      polkit_gnome
      pulseaudioFull
      rofi
      neovim
      unrar
      unzip
      zip
      python3
      gcc
      github-desktop

      stow

      (polybar.override { i3Support = true; })
      htop

      xdg-utils

      jsoncpp

      smile

      spectacle

      remmina
      gh
    ] ++ (with newest_pkgs; [ firefox ]);

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "ShareTechMono" ]; })
    iosevka
    font-awesome_5
  ];

  users.mutableUsers = true;

  programs = {
    thunar.enable = true;
    dconf.enable = true;
    gnupg.agent.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  hardware = { bluetooth.enable = true; };

  system.stateVersion = "23.05";
}
