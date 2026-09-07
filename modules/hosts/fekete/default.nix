{ inputs, self, ... }:
{
  flake.nixosConfigurations.fekete = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = {
      pkgs-stable = import inputs.nixpkgs-stable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    };

    modules = [
      { system.stateVersion = "23.05"; }
    ]
    ++ self.lib.mkFeatureModules {
      username = "fekete";
      features = [
        "base"

        "fekete"
        "homelab"

        "home-manager"
        "desktop"
        "socials"
        "shell"
        "programming"
      ];
    };
  };
}
