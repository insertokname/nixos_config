{ ... }: {
  flake.modules.nixos.programming = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      gh

      claude-code
    ];
  };
}
