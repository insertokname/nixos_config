{ ... }: {
  flake.modules.nixos.programming = { pkgs, pkgs-master, ... }: {
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        icu
        openssl
        zlib
        stdenv.cc.cc.lib
        curl
      ];
    };

    environment.systemPackages = with pkgs; [
      gcc

      gh

      pkgs-master.claude-code
      pkgs-master.cursor-cli

      nodejs

      lua
      lua-language-server
      luaformatter

      python3

      (
        with dotnetCorePackages;
        combinePackages [
          sdk_10_0
          sdk_8_0
          aspnetcore_8_0
        ]
      )
      pgadmin4-desktopmode

      pkgs.netbird-ui
    ];

    services.netbird.enable = true;

    # netbird rewrites /etc/resolv.conf to its own resolver on wt0, which
    # containers can't reach (queries arrive on the docker bridges and get
    # firewalled), so pin docker to a public resolver instead
    virtualisation.docker.daemon.settings.dns = [
      "1.1.1.1"
      "1.0.0.1"
    ];
  };
}
