{ ... }:
{
  flake.modules.nixos.homelab = { ... }:
  {
    networking.firewall.allowedTCPPorts = [
      5232
    ];

    services.radicale = {
      enable = true;
      settings = {
        server.hosts = [ "0.0.0.0:5232" ];
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/var/lib/secrets/radicale/fekete";
          htpasswd_encryption = "bcrypt";
        };
      };
    };
  };
}
