{ ... }:
{
  flake.modules.nixos.docker = { pkgs, username, ... }: {
    environment.systemPackages = with pkgs; [
      docker-compose
    ];

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    users.users.${username}.extraGroups = [ "docker" ];
  };
}
