{ inputs, ... }:
{
  flake.modules.nixos.homelab = { pkgs, username, ... }: {
    imports = [ inputs.nix-dokploy.nixosModules.default ];

    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    virtualisation.docker = {
      enable = true;
      daemon.settings = {
        live-restore = false;
        dns = [
          "192.168.100.1"
          "1.1.1.1"
        ];
      };
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
      interfaces.docker_gwbridge.allowedTCPPorts = [ 8888 ];
    };

    services.dokploy = {
      enable = true;

      database.passwordFile = "/var/lib/secrets/dokploy-db-password";
      auth.secretFile = "/var/lib/secrets/dokploy-auth-secret";
      encryption.keyFile = "/var/lib/secrets/dokploy-encryption-key";

      environment = {
        TZ = "Europe/Bucharest";
      };

      traefik = {
        extraArgs = [
          "--add-host=host.docker.internal:host-gateway"
          "-v=/var/lib/secrets/ate-htpasswd:/etc/traefik/ate-htpasswd:ro"
        ];
        dynamicConfig.ate.http = {
          routers.ate = {
            rule = "Host(`ate.insertokname.com`)";
            entryPoints = [ "web" ];
            middlewares = [ "redirect-to-https" ];
            service = "ate";
          };
          routers.ate-secure = {
            rule = "Host(`ate.insertokname.com`)";
            entryPoints = [ "websecure" ];
            tls.certResolver = "letsencrypt";
            middlewares = [ "ate-auth" ];
            service = "ate";
          };
          middlewares.ate-auth.basicAuth.usersFile = "/etc/traefik/ate-htpasswd";
          services.ate.loadBalancer.servers = [ { url = "http://host.docker.internal:8888"; } ];
        };
      };
    };
  };
}
