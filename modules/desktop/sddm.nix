{ ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, config, ... }:
    let
      systemd = config.systemd.package;

      # SDDM 0.21.0 leaks a dead greeter and never recovers.
      #
      # src/daemon/Greeter.cpp:onHelperFinished() only re-emits a failure signal
      # for HELPER_DISPLAYSERVER_ERROR, HELPER_TTY_ERROR and
      # HELPER_SESSION_ERROR. When the greeter dies but its sddm-helper exits 0
      # the status is HELPER_SUCCESS, nothing is emitted, Display::stop() is
      # never called, Display::stopped never fires, and so Seat::displayStopped()
      # never runs its `if (m_displays.isEmpty()) createDisplay(...)` recovery.
      # SDDM keeps running with a Display that believes it is still up, so the
      # Restart=always on display-manager.service never fires either, and the
      # greeter VT stays black until the machine is rebooted.
      #
      # Upstream fix (sddm/sddm#2103) is still open and unmerged, so no SDDM
      # release contains it. Recovering externally is the only option.
      watchdog = pkgs.writeShellScript "display-manager-watchdog" ''
        set -eu

        loginctl=${systemd}/bin/loginctl
        systemctl=${systemd}/bin/systemctl

        # Healthy means: the display manager is not meant to be running, or a
        # greeter session exists, or somebody has a graphical session.
        healthy() {
          "$systemctl" is-active --quiet display-manager.service || return 0

          while read -r session rest; do
            [ -n "$session" ] || continue

            class=$("$loginctl" show-session "$session" -p Class --value 2>/dev/null) || class=""
            case "$class" in
              greeter) return 0 ;;
            esac

            type=$("$loginctl" show-session "$session" -p Type --value 2>/dev/null) || type=""
            case "$type" in
              wayland | x11 | mir) return 0 ;;
            esac
          done <<SESSIONS
        $("$loginctl" list-sessions --no-legend 2>/dev/null)
        SESSIONS

          return 1
        }

        healthy && exit 0

        # Re-check, so a display manager that is merely still starting up, or
        # handing over between the greeter and a user session, is left alone.
        sleep 10
        healthy && exit 0

        echo "no greeter and no graphical session: restarting display-manager" >&2
        "$systemctl" restart display-manager.service
      '';
    in
    {
      services.displayManager.sddm = {
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [
          where-is-my-sddm-theme
          kdePackages.qt5compat
        ];
        enable = true;
        wayland = {
          enable = true;
          compositor = "kwin";
        };
        autoNumlock = true;
        theme = "where_is_my_sddm_theme";
        enableHidpi = true;
        settings = {
          General = {
            DisplayServer = "wayland";
          };
        };
      };

      environment.systemPackages = [
        (pkgs.where-is-my-sddm-theme.override {
          themeConfig.General = {
            passwordCursorColor = "#FFFFFF";
            font = "CaskaydiaMono Nerd Font Mono";
          };
        })
      ];

      systemd.services.display-manager-watchdog = {
        description = "Restart the display manager if its greeter died with nobody logged in";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = watchdog;
          TimeoutStartSec = "60s";
        };
      };

      systemd.timers.display-manager-watchdog = {
        description = "Periodically check that the display manager still has a greeter";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "2min";
          OnUnitActiveSec = "30s";
          AccuracySec = "5s";
        };
      };

      # Turning a DisplayPort monitor on is the trigger, so react to it directly
      # instead of waiting up to 30s for the timer.
      services.udev.extraRules = ''
        ACTION=="change", SUBSYSTEM=="drm", ENV{HOTPLUG}=="1", TAG+="systemd", ENV{SYSTEMD_WANTS}+="display-manager-watchdog.service"
      '';
    };
}
