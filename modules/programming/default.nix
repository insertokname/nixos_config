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
      gh

      pkgs-master.claude-code

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
    ];
  };
}
