{ ... }:
{
  flake.modules.nixos.homelab = { config, lib, ... }: {
    options.homelab.proxy = lib.mkOption {
      description = ''
        HTTPS-only sites served by the main traefik. Each entry gets a
        letsencrypt cert (auto renewed) and an http -> https redirect.
      '';
      default = { };
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          host = lib.mkOption {
            type = lib.types.str;
            example = "dav.insertokname.com";
          };
          url = lib.mkOption {
            type = lib.types.str;
            example = "http://127.0.0.1:5232";
          };
          middlewares = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
          };
        };
      });
    };

    config = {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];

      services.traefik = {
        enable = true;

        staticConfigOptions = {
          entryPoints = {
            web.address = ":80";
            websecure = {
              address = ":443";
              http.tls.certResolver = "letsencrypt";
            };
          };

          # tls-alpn on 443 instead of http-01 on 80, so port 80 challenges
          # for dokploy's own certs fall through to dokploy-traefik
          certificatesResolvers.letsencrypt.acme = {
            storage = "${config.services.traefik.dataDir}/acme.json";
            tlsChallenge = { };
          };
        };

        dynamicConfigOptions = {
          http = {
            middlewares.https-redirect.redirectScheme = {
              scheme = "https";
              permanent = true;
            };

            routers =
              lib.concatMapAttrs (name: site: {
                ${name} = {
                  rule = "Host(`${site.host}`)";
                  entryPoints = [ "websecure" ];
                  inherit (site) middlewares;
                  service = name;
                };
                "${name}-redirect" = {
                  rule = "Host(`${site.host}`)";
                  entryPoints = [ "web" ];
                  middlewares = [ "https-redirect" ];
                  service = "noop@internal";
                };
              }) config.homelab.proxy
              // {
                dokploy = {
                  rule = "PathPrefix(`/`)";
                  priority = 1;
                  entryPoints = [ "web" ];
                  service = "dokploy";
                };
              };

            services =
              lib.mapAttrs (name: site: {
                loadBalancer.servers = [ { inherit (site) url; } ];
              }) config.homelab.proxy
              // {
                dokploy.loadBalancer.servers = [ { url = "http://127.0.0.1:10080"; } ];
              };
          };

          # https routers with a specific Host() win over this catch-all, so
          # anything not declared above is passed through untouched to
          # dokploy-traefik, which terminates tls with its own certs
          tcp = {
            routers.dokploy = {
              rule = "HostSNI(`*`)";
              priority = 1;
              entryPoints = [ "websecure" ];
              tls.passthrough = true;
              service = "dokploy";
            };
            services.dokploy.loadBalancer.servers = [ { address = "127.0.0.1:10443"; } ];
          };
        };
      };
    };
  };
}
