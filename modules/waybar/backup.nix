{ pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      margin = "20 20 0 20";
      "modules-left" = [
          "sway/workspaces"
          "sway/language"
          "keyboard-state"
          "custom/pacman"
          "custom/mail"
          "sway/mode"
      ];
      "modules-center" = [
          "clock"
          "custom/weather"
      ];
      "modules-right" = [
          "pulseaudio"
          "custom/mem"
          "backlight"
          "battery"
          "tray"
      ];
      "sway/workspaces" = {
          "disable-scroll" = true;
          "persistent_workspaces" = {
              "1" = [];
              "2" = [];
              "3" = [];
              "4" = [];
          };
      };
      "sway/language" = {
          "format" = "{} ";
          "min-length" = 5;
          "tooltip" = false;
      };
      "keyboard-state" = {
          "capslock" = true;
          "format" = "{name} {icon} ";
          "format-icons" = {
              "locked" = " ";
              "unlocked" = "";
          };
      };
      "custom/pacman" = {
          "format" = "{} ";
          "signal" = 8;
          "tooltip" = false;
      };
      "custom/mail" = {
          "format" = "{} ";
          "exec" = "$HOME/.config/waybar/scripts/checkgmail.py";
          "interval" = 120;
          "signal" = 9;
          "tooltip" = false;
      };
      "sway/mode" = {
          "format" = "<span style=\"italic\">{}</span>";
      };
      "clock" = {
          "tooltip-format" = "<big>{ =%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format" = "{ =%a %d %b %I =%M %p}";
      };
      "custom/weather" = {
          "format" = "{}";
          "tooltip" = true;
          "interval" = 1800;
          "exec" = "$HOME/.config/waybar/scripts/wttr.py";
          "return-type" = "json";
      };
      "pulseaudio" = {
          "reverse-scrolling" = 1;
          "format" = "{volume}% {icon} {format_source}";
          "format-bluetooth" = "{volume}% {icon} {format_source}";
          "format-bluetooth-muted" = " {icon} {format_source}";
          "format-muted" = "婢 {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = "";
          "format-icons" = {
              "headphone" = "";
              "hands-free" = "";
              "headset" = "";
              "phone" = "";
              "portable" = "";
              "car" = "";
              "default" = [
                  "奄"
                  "奔"
                  "墳"
              ];
          };
          "on-click" = "pavucontrol";
          "min-length" = 13;
      };
      "custom/mem" = {
          "format" = "{} ";
          "interval" = 3;
          "exec" = "free -h | awk '/Mem =/{printf $3}'";
          "tooltip" = false;
      };
      "temperature" = {
          "critical-threshold" = 80;
          "format" = "{temperatureC}°C {icon}";
          "format-icons" = [
              ""
              ""
              ""
              ""
              ""
          ];
          "tooltip" = false;
      };
      "backlight" = {
          "device" = "intel_backlight";
          "format" = "{percent}% {icon}";
          "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
          ];
          "min-length" = 7;
      };
      "battery" = {
          "states" = {
              "warning" = 30;
              "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          "format-alt" = "{time} {icon}";
          "format-icons" = [
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
              ""
          ];
          "on-update" = "$HOME/.config/waybar/scripts/check_battery.sh";
      };
      "tray" = {
          "icon-size" = 16;
          "spacing" = 0;
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
