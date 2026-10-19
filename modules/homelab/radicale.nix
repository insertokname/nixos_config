{ ... }:
{
  flake.modules.nixos.homelab = { ... }:
  {
    homelab.proxy.dav = {
      host = "dav.insertokname.com";
      url = "http://127.0.0.1:5232";
    };

    services.radicale = {
      enable = true;
      settings = {
        server.hosts = [ "127.0.0.1:5232" ];
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/var/lib/secrets/radicale/fekete";
          htpasswd_encryption = "bcrypt";
        };
      };
    };
  };
}
