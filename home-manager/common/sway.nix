{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.swaylock = {
    enable = true;
    settings = {
      color = "000000";
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 100;
      line-color = "282828";
      show-failed-attempts = true;
      # Gruvbox
      inside-color = "28282800";
      ring-color = "98971a";
      key-hl-color = "b8bb26";
      bs-hl-color = "cc241d";
      inside-ver-color = "45858800";
      ring-ver-color = "458588";
      inside-wrong-color = "cc241d00";
      ring-wrong-color = "cc241d";
      inside-clear-color = "d7992100";
      ring-clear-color = "d79921";
    };
  };

  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f";
      lock = "${pkgs.swaylock}/bin/swaylock -f";
    };
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "sway-session.target";
    };
    settings = [
      {
        layer = "top";
        position = "top";
        height = 35;
        spacing = 4;
        margin-top = 6;
        margin-left = 10;
        margin-right = 10;

        modules-left = [
          "custom/logo"
          "sway/workspaces"
          "custom/music"
          "sway/language"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "tray"
          "bluetooth"
          "network"
          "pulseaudio"
          "cpu"
          "memory"
          "battery"
          "custom/logout"
          "custom/powermenu"
        ];

        "custom/logo" = {
          format = "";
          on-click = "${pkgs.rofi}/bin/rofi -show drun";
          tooltip = false;
        };

        "sway/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
          format= "{icon}";
          format-icons = {
            "2" = "";
            "3" = "󰈹";
            "4" = "";
          };
        };

        "custom/powermenu" = {
          format = "⏻";
          on-click = "${pkgs.sway}/bin/swaynag -t warning -m 'Power Menu' -B 'Shutdown' 'systemctl poweroff' -B 'Reboot' 'systemctl reboot'";
          tooltip = false;
        };

        "custom/logout" = {
          format = "󰍃";
          on-click = "${pkgs.sway}/bin/swaymsg exit";
          tooltip = false;
        };

        # "custom/weather" = {
        #   format = "{}";
        #   interval = 600;
        #   exec = "curl -sf 'wttr.in/?format=%c+%t' 2>/dev/null || echo '󰖐 --'";
        #   tooltip = false;
        #   on-click = "xdg-open https://wttr.in/";
        # };

        "custom/music" = {
          format = "{}";
          interval = 1;
          exec = "${pkgs.playerctl}/bin/playerctl metadata --format '󰎈 {{title}} - {{artist}}' 2>/dev/null || echo ''";
          max-length = 40;
          tooltip = false;
          on-click-middle = "${pkgs.playerctl}/bin/playerctl play-pause";
          on-click = "${pkgs.playerctl}/bin/playerctl previous";
          on-click-right = "${pkgs.playerctl}/bin/playerctl next";
        };

        tray = {
          icon-size = 18;
          spacing = 10;
        };

        clock = {
          interval = 1;
          format = "{:%b %d  %H:%M}";
          format-alt = "{:%A, %d %B %Y  %H:%M:%S}";
          tooltip-format = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';

          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#d79921'><b>{}</b></span>";
              days = "<span color='#ebdbb2'>{}</span>";
              weeks = "<span color='#689d6a'><b>W{}</b></span>";
              weekdays = "<span color='#cc241d'><b>{}</b></span>";
              today = "<span color='#98971a'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = "󰝟 {icon}";
          format-muted = "󰝟";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = [
              "󰕿"
              "󰖀"
              "󰕾"
            ];
          };
          on-click = "${pkgs.pulseaudioFull}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "${pkgs.pavucontrol}/bin/pavucontrol";
          on-scroll-up = "${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          on-scroll-down = "${pkgs.pulseaudioFull}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          tooltip = false;
        };

        network = {
          format-wifi = "󰖩 {signalStrength}%";
          format-ethernet = "󰈁";
          format-linked = "󰈁";
          format-disconnected = "󰖪";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          tooltip-format = ''
            {essid} ({signalStrength}%)
            {ifname}: {ipaddr}'';
          on-click-right = "nm-connection-editor";
        };

        bluetooth = {
          format = "󰂯";
          format-disabled = "󰂲";
          format-off = "󰂲";
          format-connected = "󰂱 {device_alias}";
          format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          on-click = "${pkgs.util-linux}/bin/rfkill toggle bluetooth";
          on-click-right = "${pkgs.blueman}/bin/blueman-manager";
        };

        battery = {
          interval = 10;
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}% {time}";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰂄 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          tooltip-format = "{capacity}% - {timeTo}";
        };

        backlight = {
          format = "{icon} {percent}%";
          format-icons = [
            "󰃞"
            "󰃟"
            "󰃠"
          ];
          on-scroll-up = "light -A 5";
          on-scroll-down = "light -U 5";
        };

        cpu = {
          format = "󰻠 {usage}%";
          tooltip = true;
          interval = 2;
        };

        memory = {
          format = "<span size='large'>󰍛</span> {used:0.1f}G";
          tooltip-format = "{used:0.1f}G / {total:0.1f}G";
        };

        "sway/language" = {
          format = "󰌌 {short}";
          on-click = "swaymsg input type:keyboard xkb_switch_layout next";
          tooltip-format = "{long}";
        };
      }
    ];

    style = ''
      /* Gruvbox Dark color scheme for Waybar */
      @define-color background #282828;
      @define-color background-alt #3c3836;
      @define-color background-light #504945;
      @define-color foreground #ebdbb2;
      @define-color foreground-alt #d5c4a1;

      @define-color red #cc241d;
      @define-color red-light #fb4934;
      @define-color green #98971a;
      @define-color green-light #b8bb26;
      @define-color yellow #d79921;
      @define-color yellow-light #fabd2f;
      @define-color blue #458588;
      @define-color blue-light #83a598;
      @define-color purple #b16286;
      @define-color purple-light #d3869b;
      @define-color aqua #689d6a;
      @define-color aqua-light #8ec07c;
      @define-color orange #d65d0e;
      @define-color orange-light #fe8019;

      /* General Styling */
      * {
          font-family: "JetBrainsMono Nerd Font", "NotoSans Nerd Font", "Font Awesome 6 Free", sans-serif;
          font-size: 13px;
          font-weight: bold;
          min-height: 0;
          padding: 0;
          margin: 0;
      }

      /* Main bar */
      window#waybar {
          background-color: rgba(40, 40, 40, 0.0);
          color: @foreground;
          transition-property: background-color;
          transition-duration: 0.5s;
          border-radius: 15px;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      /* Tooltip styling */
      tooltip {
          background-color: @background;
          border: 2px solid @green;
          border-radius: 8px;
      }

      tooltip label {
          color: @foreground;
          padding: 4px;
      }

      /* Module box styling */
      #custom-logo,
      #workspaces,
      #workspaces button,
      #mode,
      #tray,
      #clock,
      #battery,
      #cpu,
      #memory,
      #backlight,
      #network,
      #bluetooth,
      #pulseaudio,
      #custom-weather,
      #custom-music,
      #custom-logout,
      #custom-powermenu,
      #custom-micro,
      #custom-swaync,
      #language,
      #sway-language {
          background-color: @background;
          border-radius: 15px;
          padding: 4px 12px;
          margin: 4px 3px;
          color: @foreground;
      }

      /* Logo button */
      #custom-logo {
          font-size: 16px;
          padding: 4px 14px;
          color: @green;
          margin-left: 6px;
      }

      #custom-logo:hover {
          background-color: @background-alt;
          color: @green-light;
      }

      /* Workspaces */
      #workspaces {
          padding: 0 6px;
          margin: 4px 3px;
      }

      #workspaces button {
          padding: 4px 8px;
          margin: 2px 2px;
          color: @foreground-alt;
          background-color: transparent;
          border-radius: 10px;
          transition: all 0.2s ease;
      }

      #workspaces button:hover {
          background-color: @background-alt;
          color: @foreground;
      }

      #workspaces button.focused,
      #workspaces button.active {
          background-color: @green;
          color: @background;
          border-radius: 10px;
      }

      #workspaces button.urgent {
          background-color: @red;
          color: @foreground;
          animation: blink 0.5s linear infinite alternate;
      }

      @keyframes blink {
          to {
              background-color: @red-light;
          }
      }

      /* Sway Mode */
      #mode {
          background-color: @yellow;
          color: @background;
          font-weight: bold;
      }

      /* Clock */
      #clock {
          font-size: 13px;
          color: @foreground;
          padding: 4px 12px;
      }

      #clock:hover {
          background-color: @background-alt;
      }

      /* Weather */
      #custom-weather {
          color: @blue-light;
          font-size: 14px;
      }

      /* Music */
      #custom-music {
          color: @purple-light;
          font-size: 12px;
      }

      #custom-music:hover {
          background-color: @background-alt;
      }

      /* Tray */
      #tray {
          padding: 4px 10px;
      }

      #tray > .passive {
          -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: @red;
      }

      /* Battery */
      #battery {
          color: @green-light;
      }

      #battery.charging,
      #battery.plugged {
          color: @aqua-light;
      }

      #battery.warning:not(.charging) {
          background-color: @yellow;
          color: @background;
      }

      #battery.critical:not(.charging) {
          background-color: @red;
          color: @foreground;
          animation: blink 0.5s linear infinite alternate;
      }

      /* Network */
      #network {
          color: @yellow-light;
      }

      #network.disconnected {
          color: @red-light;
          background-color: @background-alt;
      }

      #network.disabled {
          color: @foreground-alt;
      }

      /* Bluetooth */
      #bluetooth {
          color: @blue-light;
      }

      #bluetooth.connected {
          color: @aqua-light;
      }

      #bluetooth.disabled,
      #bluetooth.off {
          color: @foreground-alt;
          background-color: @background-alt;
      }

      /* Pulseaudio/Audio */
      #pulseaudio {
          color: @aqua-light;
      }

      #pulseaudio.muted {
          color: @red-light;
          background-color: @background-alt;
      }

      #pulseaudio:hover {
          background-color: @background-alt;
      }

      /* Microphone */
      #custom-micro {
          color: @orange-light;
          font-size: 15px;
      }

      /* Backlight */
      #backlight {
          color: @yellow-light;
      }

      /* CPU and Memory */
      #cpu {
          color: @blue-light;
      }

      #memory {
          color: @purple-light;
      }

      /* Logout button */
      #custom-logout {
          color: @orange-light;
          font-size: 15px;
          padding: 4px 14px;
      }

      #custom-logout:hover {
          background-color: @orange;
          color: @foreground;
      }

      /* Power menu */
      #custom-powermenu {
          color: @red-light;
          font-size: 15px;
          padding: 4px 14px;
          margin-right: 6px;
      }

      #custom-powermenu:hover {
          background-color: @red;
          color: @foreground;
      }

      /* Notification center */
      #custom-swaync {
          color: @yellow-light;
          font-size: 14px;
      }

      /* Keyboard layout */
      #language,
      #sway-language {
          background-color: @background;
          color: @green;
          font-size: 12px;
      }
    '';
  };

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    systemd = {
      enable = true;
      variables = [ "--all" ];
    };

    config = rec {
      modifier = "Mod4";
      terminal = "alacritty";

      fonts = {
        names = [ "NotoSans Nerd Font" ];
        size = 10.0;
      };

      input = {
        "*" = {
          xkb_layout = "us,ro";
          xkb_variant = ",std";
          xkb_options = "grp:ctrl_space_toggle";
        };
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
          dwt = "enabled";
        };
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+Return" = "exec ${terminal}";

        "${modifier}+period" = "exec rofimoji --action type copy --skin-tone neutral";

        "${modifier}+u" = "exec wtype '̈'";
        "${modifier}+s" = "exec wtype ß";

        "${modifier}+q" = "kill";

        "${modifier}+d" = "exec rofi -show drun";

        "${modifier}+h" = "focus left";
        "${modifier}+j" = "focus down";
        "${modifier}+k" = "focus up";
        "${modifier}+l" = "focus right";

        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+j" = "move down";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+l" = "move right";

        "${modifier}+g" = "splith";
        "${modifier}+v" = "splitv";

        "${modifier}+f" = "fullscreen toggle";

        # "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" = "exec swaynag -t warning -m 'Exit sway?' -B 'Yes' 'swaymsg exit'";

        "XF86AudioRaiseVolume" =
          "exec pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ +5%";
        "XF86AudioLowerVolume" =
          "exec pactl set-sink-mute @DEFAULT_SINK@ 0 && pactl set-sink-volume @DEFAULT_SINK@ -5%";
        "XF86AudioMute" = "exec pactl set-sink-mute @DEFAULT_SINK@ toggle";
        "XF86AudioMicMute" = "exec pactl set-source-mute @DEFAULT_SOURCE@ toggle";

        "XF86PowerOff" = "exec systemctl poweroff";

        "XF86AudioPlay" = "exec playerctl play-pause";
        "XF86AudioPause" = "exec playerctl play-pause";
        "XF86AudioNext" = "exec playerctl next";
        "XF86AudioPrev" = "exec playerctl previous";
        "XF86AudioStop" = "exec playerctl stop";

        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86MonBrightnessDown" = "exec light -U 10";

        "${modifier}+Shift+s" = "exec slurp | grim -g - - | wl-copy";
        "Print" = "exec grim - | wl-copy";
      };

      startup = [
        { command = "nm-applet"; }
        {
          command = "mako";
        }
        {
          command = "swaybg -i $(find ~/.config/nitrogen/bg -type f | shuf -n 1) -m fill";
        }
        {
          command = "swaymsg workspace 2";
        }
        {
          command = "firefox & vesktop & code -n";
        }
      ];

      assigns = {
        "2" = [
          { app_id = "code"; }
          { app_id = "Code"; }
          { class = "Code"; }
        ];
        "3" = [ { app_id = "firefox"; } ];
        "4" = [ { app_id = "vesktop"; } ];
      };

      window = {
        titlebar = true;
        border = 5;
      };

      floating = {
        titlebar = true;
        border = 3;
        criteria = [
          {
            title = "Picture-in-Picture";
          }
        ];
      };

      gaps = {
        inner = 20;
      };

      # Gruvbox
      colors = {
        focused = {
          border = "#98971a";
          background = "#98971a";
          text = "#1d2021";
          indicator = "#b16286";
          childBorder = "#1d2021";
        };
        focusedInactive = {
          border = "#1d2021";
          background = "#1d2021";
          text = "#d79921";
          indicator = "#b16286";
          childBorder = "#1d2021";
        };
        unfocused = {
          border = "#1d2021";
          background = "#1d2021";
          text = "#d79921";
          indicator = "#b16286";
          childBorder = "#1d2021";
        };
        urgent = {
          border = "#cc241d";
          background = "#cc241d";
          text = "#ffffff";
          indicator = "#cc241d";
          childBorder = "#cc241d";
        };
      };

      bars = [ ];

      output = {
        eDP-1 = {
          mode = "1920x1200";
        };
      };
    };

    extraConfig = ''
      # Include NixOS sway config for portal integration
      include /etc/sway/config.d/*

      # Enable title window icons
      for_window [all] title_format "%title %app_id"
      for_window [all] title_window_icon on

      # Inhibit idle for fullscreen apps
      for_window [app_id="^.*"] inhibit_idle fullscreen
    '';
  };

  home.pointerCursor = {
    name = "phinger-cursors-dark";
    package = pkgs.phinger-cursors;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "phinger-cursors-dark";
    };
    gtk.enable = true;
  };
}
