{ ... }: {
  flake.modules.nixos.programming = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      lua
      lua-language-server
      luaformatter
    ];
  };
}
