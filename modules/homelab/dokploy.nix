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

      database.passwordFile = "/var/lib/secrets/dokploy-db-password";
      auth.secretFile = "/var/lib/secrets/dokploy-auth-secret";
      encryption.keyFile = "/var/lib/secrets/dokploy-encryption-key";

      environment = {
        TZ = "Europe/Bucharest";
      };
    };
  };

}
