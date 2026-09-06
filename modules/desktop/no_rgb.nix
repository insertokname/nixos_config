{ ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    let
      pythonEnv = pkgs.python3.withPackages (ps: [ ps.openrgb-python ]);

      no-rgb = pkgs.writeScriptBin "no-rgb" ''
        #!${pythonEnv}/bin/python3
        import sys
        import time

        from openrgb import OpenRGBClient
        from openrgb.utils import DeviceType, OpenRGBDisconnected, RGBColor

        HOST = "127.0.0.1"
        PORT = 6742
        RETRIES = 10
        RETRY_DELAY = 1.0  # seconds

        # The SDK server accepts connections before it has finished probing
        # SMBus/I2C/USB, so a client that connects immediately sees an empty
        # device list and silently does nothing.  Wait until the reported
        # device count is non-zero and has stopped growing.
        DETECT_TIMEOUT = 60.0  # seconds
        DETECT_POLL = 1.0  # seconds
        DETECT_STABLE = 3  # consecutive polls with an unchanged count

        # Re-check the device list on this interval so hotplugged devices get
        # blacked out too, and so anything that lights itself back up (firmware
        # defaults after a resume, say) gets corrected.
        POLL_INTERVAL = 10.0  # seconds

        BLACK = RGBColor(0, 0, 0)

        def log(msg):
            print(f"no-rgb: {msg}", flush=True)

        def connect():
            last_exc = None
            for _ in range(RETRIES):
                try:
                    return OpenRGBClient(address=HOST, port=PORT, name="no-rgb")
                except (ConnectionRefusedError, OSError) as exc:
                    last_exc = exc
                    time.sleep(RETRY_DELAY)
            raise SystemExit(f"no-rgb: could not reach openrgb server: {last_exc}")

        def wait_for_devices(client):
            deadline = time.monotonic() + DETECT_TIMEOUT
            count = len(client.devices)
            stable = 0
            while time.monotonic() < deadline:
                if count > 0 and stable >= DETECT_STABLE:
                    return count
                time.sleep(DETECT_POLL)
                client.update()
                current = len(client.devices)
                stable = stable + 1 if current == count else 0
                count = current
            log(f"timed out waiting for device detection, continuing with {count}")
            return count

        def identity(device):
            meta = device.metadata
            return (device.name, meta.serial, meta.location)

        def is_black(device):
            return all(
                led.red == 0 and led.green == 0 and led.blue == 0
                for led in device.colors
            )

        def enforce(client, seen, blacked):
            current = set()
            for device in client.devices:
                key = identity(device)
                current.add(key)
                if key not in seen:
                    seen.add(key)
                    what = "keyboard, leaving alone" if device.type == DeviceType.KEYBOARD else "device"
                    log(f"found {what}: {device.name}")
                if device.type == DeviceType.KEYBOARD:
                    continue
                if is_black(device):
                    continue
                try:
                    device.set_color(BLACK)
                except (OpenRGBDisconnected, OSError):
                    raise
                except Exception as exc:
                    print(f"no-rgb: failed on {device.name}: {exc}", file=sys.stderr)
                    continue
                if key not in blacked:
                    blacked.add(key)
                    log(f"blacked out {device.name}")
            # Forget devices that went away, so a re-plug is reported again.
            seen &= current
            blacked &= current

        def main():
            while True:
                client = connect()
                wait_for_devices(client)
                seen = set()
                blacked = set()
                try:
                    while True:
                        enforce(client, seen, blacked)
                        time.sleep(POLL_INTERVAL)
                        client.update()
                except (OpenRGBDisconnected, OSError) as exc:
                    log(f"lost the openrgb connection ({exc}), reconnecting")
                    time.sleep(RETRY_DELAY)

        if __name__ == "__main__":
            sys.exit(main())
      '';
    in
    {
      config = {
        services.hardware.openrgb.enable = true;

        systemd.services.no-rgb = {
          description = "Keep OpenRGB devices except the keyboard turned off";
          after = [ "openrgb.service" ];
          requires = [ "openrgb.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${no-rgb}/bin/no-rgb";
            Restart = "always";
            RestartSec = "5s";
          };
        };
      };
    };
}
