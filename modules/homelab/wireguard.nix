{ ... }:
{
  flake.modules.nixos.homelab =
    { pkgs, ... }:
    {
      networking.nat = {
        enable = true;
        externalInterface = "enp4s0";
        internalInterfaces = [ "wg0" ];
        enableIPv6 = true;
      };

      networking.firewall.allowedUDPPorts = [ 51820 ];

      networking.wireguard.interfaces.wg0 = {
        ips = [ "10.73.41.1/24" ];
        listenPort = 51820;
        privateKeyFile = "/var/lib/secrets/wireguard/server.key";

        peers = [
          {
            # macbook
            publicKey = "zfzICVhsa2G/dXln2GHeDqWCmNAuScUWeUDemrcGkzk=";
            allowedIPs = [ "10.73.41.2/32" ];
          }
          {
            # phone
            publicKey = "XksuGNk9SdlvlCZvWb6ng/ALRmtYKhrJjI7gbqxELlo=";
            allowedIPs = [ "10.73.41.3/32" ];
          }
        ];
      };

      environment.systemPackages = [ pkgs.wireguard-tools ];
    };
}
