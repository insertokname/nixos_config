{ ... }:
{
  flake.modules.nixos.homelab = { ... }: {
    homelab.proxy.ate = {
      host = "ate.insertokname.com";
      url = "http://127.0.0.1:8888";
      middlewares = [ "ate-auth" ];
    };

    services.traefik.dynamicConfigOptions.http.middlewares.ate-auth.basicAuth.usersFile =
      "/run/credentials/traefik.service/ate-htpasswd";

    systemd.services.traefik.serviceConfig.LoadCredential = [
      "ate-htpasswd:/var/lib/secrets/ate-htpasswd"
    ];
  };
}
