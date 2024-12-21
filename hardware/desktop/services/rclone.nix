# shamelessly stolen from: https://tcude.net/setting-up-rclone-with-google-drive/
{ pkgs, ... }: {
  systemd.services.rclone-gdrive = {
    description = "rclone for obi-remote";
    after = [ "networking.service" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.rclone}/bin/rclone mount --config=/home/fekete/.config/rclone/rclone.conf obi-remote: /mnt/gdrive --async-read --buffer-size 32M --allow-other --dir-cache-time 300h --poll-interval 1m --max-read-ahead 200M --transfers 24 --drive-chunk-size=32M --cache-chunk-total-size 2G --cache-chunk-size 16M --cache-workers=24 --buffer-size=32M --vfs-cache-mode full --vfs-read-chunk-size 32M --vfs-cache-max-age 1h";
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
