{ ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, username, ... }:

    let
      silenceDrivesScript = pkgs.writeShellScriptBin "silence-drives" ''
        #!/usr/bin/env bash
        for disk in /sys/block/sd*; do
          name=$(basename "$disk")
          rotational=$(cat "$disk/queue/rotational" 2>/dev/null || echo 0)
          if [ "$rotational" = "1" ]; then
            ${pkgs.hdparm}/sbin/hdparm -y "/dev/$name"
          fi
        done
      '';

      silenceDrivesDesktopItem = pkgs.makeDesktopItem {
        name = "silence-drives";
        desktopName = "Silence Drives";
        exec = "sudo ${silenceDrivesScript}/bin/silence-drives";
        terminal = false;
        categories = [ "System" ];
      };
    in
    {
      environment.systemPackages = [
        silenceDrivesScript
        silenceDrivesDesktopItem
      ];

      security.sudo.extraRules = [
        {
          users = [ username ];
          commands = [
            {
              command = "${silenceDrivesScript}/bin/silence-drives";
              options = [ "NOPASSWD" ];
            }
          ];
        }
      ];
    };
}
