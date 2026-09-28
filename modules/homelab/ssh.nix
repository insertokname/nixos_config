{ ... }:
{
  flake.modules.nixos.homelab = { username, ... }: {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "yes";
        AllowUsers = [
          "root"
          username
        ];
        MaxAuthTries = 3;
      };
    };
  };
}
