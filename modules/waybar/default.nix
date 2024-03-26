{ pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      layer = "top";
      position = "top";
      height = 35;
      spacing = 4;
      margin-top = 10;
      margin-bottom = 0;
      margin-left = 10;
      margin-right = 10;
      # Choose the order of the modules
      modules-left = [
        "custom/launcher"
        "pulseaudio"
        "backlight"
        "cpu"
        "memory"
        "temperature"
        # "idle_inhibitor"
        "hyprland/workspaces"
      ];
      modules-center = [
        "wlr/taskbar"
      ];
      modules-right = [
        # "custom/layout"
        "custom/media"
        # "custom/updater"
        # "custom/snip"
        "keyboard-state"
        # "battery#bat2"
        "network"
        "battery"
        # "tray"
        "clock"
        "custom/power"
      ];
      # Modules configuration
      "hyprland/workspaces" = {
        # format = "{icon}";
        # format-icons = {
        #   1 = "";
        #   2 = "";
        #   3 = "";
        #   4 = "";
        #   5 = "";
        #   # active = "";
        #   # default = ""
        # };
        sort-by-number = true;
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
        on-click = "activate";
      };
      keyboard-state = {
        numlock = true;
        capslock = true;
        format = " {name} {icon}";
        format-icons = {
          locked = "";
          unlocked = "";
        };
      };
      "wlr/taskbar" = {
        format = "{icon}";
        icon-size = 20;
        icon-theme = "Star";
        tooltip-format = "{title}";
        on-click = "activate";
        # on-click-middle = "close"
        # on-click-right = "activate"
      };
      # "sway/language" = {
      #   format = " {}"
      # };
      idle_inhibitor = {
        format = "{icon}";
        format-icons = {
          activated = "";
          deactivated = "";
        };
      };
      tray = {
        icon-size = 20;
        spacing = 10;
      };
      clock = {
        # timezone = "America/New_York";
        format = "{ =%H =%M      %d.%m  }";
        tooltip-format = "{calendar}";
        # format-alt = "{ =%d.%m.%Y}"
      };
      cpu = {
        format = "{usage}% ";
        # tooltip = false
      };
      memory = {
        format = "{}% ";
      };
      temperature = {
        # thermal-zone = 2;
        # hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
        critical-threshold = 80;
        # format-critical = "{temperatureC}°C {icon}";
        format = "{temperatureC}°C {icon}";
        format-icons = [
          ""
          ""
          ""
        ];
      };
      backlight = {
        # TODO backlight keys do not work
        format = "{percent}% {icon}";
        format-icons = [
          ""
          ""
        ];
      };
      battery = {
        states = {
          # good = 95
          warning = 30;
          critical = 15;
        };
        format = "{capacity}% {icon}";
        format-charging = "{capacity}% ";
        format-plugged = "{capacity}% ";
        format-alt = "{time} {icon}";
        format-icons = [
          ""
          ""
          ""
          ""
          ""
        ];
      };
      # battery#bat2 = {
      #   bat = "BAT2"
      # };
      network = {
        # interface = "wlp2*"; # (Optional) To force the use of this interface
        format-wifi = "{essid} ({signalStrength}%) ";
        format-ethernet = "Connected  ";
        tooltip-format = "{ifname} via {gwaddr} ";
        format-linked = "{ifname} (No IP) ";
        format-disconnected = "Disconnected ⚠";
        format-alt = "{ifname} = {ipaddr}/{cidr}";
        on-click-right = "bash ~/.config/rofi/wifi_menu/rofi_wifi_menu";
      };
      pulseaudio = {
        format = "{volume}% {icon}";
        format-bluetooth = "{volume}% {icon}";
        format-bluetooth-muted = "{icon} {format_source}";
        format-muted = "{format_source}";
        format-source = "";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
        on-click = "pavucontrol";
      };
      "custom/media" = {
        format = "{icon} {}";
        return-type = "json";
        max-length = 15;
        format-icons = {
          spotify = " ";
          default = " ";
        };
        escape = true;
        exec = "$HOME/.config/system_scripts/mediaplayer.py 2> /dev/null";
        on-click = "playerctl play-pause";
      };
      "custom/launcher" = {
        format = "";
        on-click = "wofi --show drun";
        on-click-right = "killall wofi";
      };
      "custom/power" = {
        format = " ";
        on-click = "nwg-bar";
        on-click-right = "killall nwg-bar";
      };
      # "custom/layout" = {
      #   format = "";
      #   on-click = "bash ~/.config/system_scripts/layout.sh"
      # };
      "custom/updater" = {
        format = "  {} Updates";
        exec = "checkupdates | wc -l";
        exec-if = "[[ $(checkupdates | wc -l) != 0 ]]";
        interval = 15;
        on-click = "kitty -e yay -Syu";
      };
    };
    style = ''
      * {
          border: none;
          border-radius: 0;
          /* `otf-font-awesome` is required to be installed for icons */
          font-family: Liberation Mono;
          min-height: 20px;
      }

      window#waybar {
          background: transparent;
      }

      window#waybar.hidden {
          opacity: 0.2;
      }

      #workspaces {
          margin-right: 8px;
          border-radius: 10px;
          transition: none;
          background: #383c4a;
      }

      #workspaces button {
          transition: none;
          color: #7c818c;
          background: transparent;
          padding: 5px;
          font-size: 18px;
      }

      #workspaces button.persistent {
          color: #7c818c;
          font-size: 12px;
      }

      /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
      #workspaces button:hover {
          transition: none;
          box-shadow: inherit;
          text-shadow: inherit;
          border-radius: inherit;
          color: #383c4a;
          background: #7c818c;
      }

      #workspaces button.focused {
          color: white;
      }

      #language {
          padding-left: 16px;
          padding-right: 8px;
          border-radius: 10px 0px 0px 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #keyboard-state {
          margin-right: 8px;
          padding-right: 16px;
          border-radius: 0px 10px 10px 0px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #custom-pacman {
          padding-left: 16px;
          padding-right: 8px;
          border-radius: 10px 0px 0px 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #custom-mail {
          margin-right: 8px;
          padding-right: 16px;
          border-radius: 0px 10px 10px 0px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #mode {
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #clock {
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px 0px 0px 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #custom-weather {
          padding-right: 16px;
          border-radius: 0px 10px 10px 0px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #pulseaudio {
          margin-right: 8px;
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #pulseaudio.muted {
          background-color: #90b1b1;
          color: #2a5c45;
      }

      #custom-mem {
          margin-right: 8px;
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #temperature {
          margin-right: 8px;
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #temperature.critical {
          background-color: #eb4d4b;
      }

      #backlight {
          margin-right: 8px;
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #battery {
          margin-right: 8px;
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      #battery.charging {
          color: #ffffff;
          background-color: #26A65B;
      }

      #battery.warning:not(.charging) {
          background-color: #ffbe61;
          color: black;
      }

      #battery.critical:not(.charging) {
          background-color: #f53c3c;
          color: #ffffff;
          animation-name: blink;
          animation-duration: 0.5s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
      }

      #tray {
          padding-left: 16px;
          padding-right: 16px;
          border-radius: 10px;
          transition: none;
          color: #ffffff;
          background: #383c4a;
      }

      @keyframes blink {
          to {
              background-color: #ffffff;
              color: #000000;
          }
      }    
    '';
  };
}
