{ inputs, self, ... }:
{
  flake.nixosConfigurations.fekete = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      { system.stateVersion = "23.05"; }
    ]
    ++ self.lib.mkFeatureModules {
      username = "fekete";
      features = [
        "fekete"
        "base"
        "desktop"
        "shell"
        "home-manager"
        "socials"
      ];
    };
  };
}
