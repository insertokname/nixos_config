{ inputs, ... }:
{
  flake.modules.nixos.homelab = { config, ... }: {
    imports = [ inputs.nix-dokploy.nixosModules.default ];

    # dokploy uses swarm and they are not compatible
    virtualisation.docker.daemon.settings.live-restore = false;

    services.dokploy = {
      enable = true;

      database.passwordFile = "/var/lib/secrets/dokploy-db-password";
      auth.secretFile = "/var/lib/secrets/dokploy-auth-secret";
      encryption.keyFile = "/var/lib/secrets/dokploy-encryption-key";

      environment = {
        TZ = "Europe/Bucharest";
      };
    };

    # upstream runs dokploy-traefik from a script that hardcodes -p 80:80
    # -p 443:443, but the main traefik owns those (see traefik.nix), so run the
    # container ourselves and publish it on loopback only
    systemd.services.dokploy-traefik.enable = false;

    virtualisation.oci-containers.containers.dokploy-traefik = {
      image = config.services.dokploy.traefik.image;
      autoStart = false;
      networks = [ "dokploy-network" ];
      ports = [
        "127.0.0.1:10080:80"
        "127.0.0.1:10443:443"
      ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "${config.services.dokploy.dataDir}/traefik/traefik.yml:/etc/traefik/traefik.yml"
        "${config.services.dokploy.dataDir}/traefik/dynamic:/etc/dokploy/traefik/dynamic"
      ];
    };

    systemd.services.docker-dokploy-traefik = {
      after = [ "dokploy-stack.service" ];
      requires = [ "dokploy-stack.service" ];
    };

    # dokploy writes traefik.yml on its first start, so start the container
    # once it exists instead of letting docker create a directory in its place
    systemd.paths.docker-dokploy-traefik = {
      wantedBy = [ "multi-user.target" ];
      pathConfig.PathExists = "${config.services.dokploy.dataDir}/traefik/traefik.yml";
    };
  };
}
