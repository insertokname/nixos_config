{ inputs, ... }: {
  flake.modules.nixos.programming = { pkgs-stable, ... }: {
    environment.systemPackages = with pkgs-stable; [
      vscode
    ];
  };
}
