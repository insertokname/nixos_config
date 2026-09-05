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
        from openrgb.utils import DeviceType, RGBColor

        HOST = "127.0.0.1"
        PORT = 6742
        RETRIES = 10
        RETRY_DELAY = 1.0  # seconds

        def connect():
            last_exc = None
            for _ in range(RETRIES):
                try:
                    return OpenRGBClient(address=HOST, port=PORT, name="no-rgb")
                except (ConnectionRefusedError, OSError) as exc:
                    last_exc = exc
                    time.sleep(RETRY_DELAY)
            raise SystemExit(f"no-rgb: could not reach openrgb server: {last_exc}")

        def main():
            client = connect()
            for device in client.devices:
                if device.type == DeviceType.KEYBOARD:
                    continue
                try:
                    device.set_color(RGBColor(0, 0, 0))
                except Exception as exc:
                    print(f"no-rgb: failed on {device.name}: {exc}", file=sys.stderr)
            return 0

        if __name__ == "__main__":
            sys.exit(main())
      '';
    in
    {
      config = {
        services.hardware.openrgb.enable = true;

        systemd.services.no-rgb = {
          description = "Turn off all OpenRGB devices except the keyboard";
          after = [ "openrgb.service" ];
          requires = [ "openrgb.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${no-rgb}/bin/no-rgb";
          };
        };
      };
    };
}
