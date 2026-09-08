{ ... }:
{
  flake.modules.nixos.homelab = { username, ... }: {
    services.sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };

    users.users.${username}.extraGroups = [ "uinput" ];
  };
}
