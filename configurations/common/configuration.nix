{ config, pkgs, ... }: {
  imports = [ ./desktop_environment.nix ];

  # linux driver
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
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

  environment.systemPackages = with pkgs; [
    nixfmt
    home-manager
    vesktop
    # alacritty
    dmenu
    git
    gnome.gnome-keyring
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
    firefox
    python3
    gcc
    vscode
    github-desktop

    stow

    (polybar.override { i3Support = true; })
    htop

    xdg-utils

    jsoncpp

    smile

    spectacle

    remmina
    gh # github cli
    #git-credential-manager 
    #dotnet-runtime_7
    #dotnet-aspnetcore_7
    #dotnetCorePackages.aspnetcore_7_0
    #dotnetCorePackages.runtime_7_0
    #dotnetCorePackages.sdk_7_0
    #dotnet-sdk_7

    #gnupg
    #pass
    #pinentry
    #pinentry-curses
  ];

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
