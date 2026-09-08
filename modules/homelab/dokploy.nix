{ inputs, ... }:
{
  flake.modules.nixos.homelab = { pkgs, username, ... }: {
    imports = [ inputs.nix-dokploy.nixosModules.default ];

    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    virtualisation.docker = {
      enable = true;
      daemon.settings.live-restore = false;
    };

    users.users.${username}.extraGroups = [ "docker" ];

    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [
        80
        443
      ];
    };

    services.dokploy = {
      enable = true;

      database.passwordFile = "/home/fekete/dotfiles/new_nixos_config/secrets/dokploy-db-password";
      auth.secretFile = "/home/fekete/dotfiles/new_nixos_config/secrets/dokploy-auth-secret";
      encryption.keyFile = "/home/fekete/dotfiles/new_nixos_config/secrets/dokploy-encryption-key";
    };
  };

}
