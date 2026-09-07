{ ... }: {
  flake.modules.nixos.programming = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      claude-code
      gh
    ];
  };
}
