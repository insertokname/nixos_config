#shamelessly stolen from: https://tcude.net/setting-up-rclone-with-google-drive/
{ pkgs, ... }: {
  systemd.services.rclone-gdrive = {
    description = "rclone for obi-remote";
    after = [ "networking.service" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.rclone}/bin/rclone mount --config=/home/fekete/.config/rclone/rclone.conf obi-remote: /mnt/gdrive --allow-other --cache-db-purge --fast-list --poll-interval 10m";
      ExecStop = "${pkgs.util-linux}/bin/umount -u /mnt/gdrive";
      Restart = "always";
      RestartSec = 10;
    };
    preStart = ''
      if [ ! -d /mnt/gdrive ]; then
        echo "Directory /mnt/gdrive does not exist. Creating it..."
        mkdir -p /mnt/gdrive
      fi
    '';
  };
}
