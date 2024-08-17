{ pkgs, lib, ... }:

{
  programs.waybar = {
    enable = true;
  };

  xdg.configFile."waybar/config".text = 
  # json
  ''
  {
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
  }
  '';

  xdg.configFile."waybar/style.css".text =  
  # css
  ''
  * {
    /* `otf-font-awesome` is required to be installed for icons */
    font-family: FontAwesome, JetBrains Mono, Roboto, Helvetica, Arial, sans-serif;
    font-size: 13px;
  }

  window#waybar {
    background-color: transparent;
    color: #ffffff;
    transition-property: background-color;
    transition-duration: .5s;
  }

  window#waybar.hidden {
    opacity: 0.2;
  }

  window#waybar.empty {
    background-color: transparent;
  }

  /*
  window#waybar.solo {
      background-color: #FFFFFF;
  }
  */

  button {
    /* Use box-shadow instead of border so the text isn't offset */
    /* box-shadow: inset 0 -3px transparent; */
    /* Avoid rounded borders under each button name */
    border: none;
    border-radius: 99px;
    transition: background-color 100ms;
  }

  /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
  button:hover {
    /* background: inherit; */
    background-color: #ffffff;
    /* box-shadow: inset 0 -3px #ffffff; */
  }

  .modules-right,
  .modules-left,
  .modules-center {
    background-color: rgba(0, 0, 0, .9);
    border-radius: 99px;
    padding-left: 8px;
    padding-right: 8px;
  }

  #workspaces button {
    padding: 0px 10px;
    background-color: transparent;
    color: #ffffff;
    transition: all 100ms;
  }

  #workspaces button:hover {
    background-color: #ffffff;
    color: #000000;
  }

  #workspaces button.active {
    background-color: #dcd7ba;
    color: #000000;
  }

  #workspaces button.urgent {
    background-color: #eb4d4b;
  }

  /*
  #mode {
    background-color: #64727D;
    border-bottom: 3px solid #ffffff;
  }
  */

  #custom-updater,
  #custom-media,
  #custom-launcher,
  #custom-power,
  #clock,
  #battery,
  #cpu,
  #memory,
  #disk,
  #temperature,
  #backlight,
  #network,
  #pulseaudio,
  #wireplumber,
  #custom-media,
  #tray,
  #mode,
  #idle_inhibitor,
  #scratchpad,
  #mpd {
    padding: 0 8px;
  }

  #custom-updater:hover,
  #custom-launcher:hover,
  #custom-power:hover,
  #clock:hover,
  #network:hover,
  #pulseaudio:hover {
    background-color: #ffffff;
    color: #000000;
  }

  #window,
  #workspaces {
    margin: 0 4px;
  }

  /* If workspaces is the leftmost module, omit left margin */
  .modules-left>widget:first-child>#workspaces {
    margin-left: 0;
  }

  /* If workspaces is the rightmost module, omit right margin */
  .modules-right>widget:last-child>#workspaces {
    margin-right: 0;
  }

  #clock {
    /* background-color: #64727D; */
  }

  #battery {
    /* background-color: #ffffff; */
    /* color: #000000; */
  }

  #battery.charging,
  #battery.plugged {
    color: #ffffff;
    background-color: #26A65B;
  }

  @keyframes blink {
    to {
      background-color: #ffffff;
      color: #000000;
    }
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

  /* label:hover {
     background-color: #000000;
     color: #ffffff;
  }*/

  #cpu {
    /*
    background-color: #2ecc71;
    color: #000000;
    */
  }

  #memory {
    /*
    background-color: #9b59b6;
    */
  }

  #disk {
    /*
    background-color: #964B00;
    */
  }

  #backlight {
    /*
    background-color: #90b1b1;
    */
  }

  #network {
    /*
    background-color: #2980b9;
    */
  }

  #network.disconnected {
    background-color: #f53c3c;
  }

  #pulseaudio {
    /*
    background-color: #f1c40f;
    color: #000000;
    */
  }

  #pulseaudio.muted {
    background-color: #f53c3c;
    color: #000000;
  }

  /*
  #wireplumber {
    background-color: #fff0f5;
    color: #000000;
  }

  #wireplumber.muted {
    background-color: #f53c3c;
  }
  */

  #custom-media {
    background-color: #66cc99;
    color: #2a5c45;
    min-width: 100px;
  }

  #custom-media.custom-spotify {
    background-color: #66cc99;
  }

  #custom-media.custom-vlc {
    background-color: #ffa000;
  }

  #temperature {
    /* background-color: #f0932b; */
  }

  #temperature.critical {
    background-color: #eb4d4b;
  }

  #tray {
    background-color: #2980b9;
  }

  #tray>.passive {
    -gtk-icon-effect: dim;
  }

  #tray>.needs-attention {
    -gtk-icon-effect: highlight;
    background-color: #eb4d4b;
  }

  #idle_inhibitor {
    /* background-color: #2d3436; */
  }

  #idle_inhibitor.activated {
    background-color: #ecf0f1;
    color: #2d3436;
    border-radius: 99px;
  }

  #mpd {
    background-color: #66cc99;
    color: #2a5c45;
  }

  #mpd.disconnected {
    background-color: #f53c3c;
  }

  #mpd.stopped {
    background-color: #90b1b1;
  }

  #mpd.paused {
    background-color: #51a37a;
  }

  #language {
    background: #00b093;
    color: #740864;
    padding: 0 5px;
    margin: 0 5px;
    min-width: 16px;
  }

  #keyboard-state {
    background: #97e1ad;
    color: #000000;
    padding: 0 0px;
    margin: 0 5px;
    min-width: 16px;
  }

  #keyboard-state>label {
    padding: 0 5px;
  }

  #keyboard-state>label.locked {
    background: rgba(0, 0, 0, 0.2);
  }

  #scratchpad {
    background: rgba(0, 0, 0, 0.2);
  }

  #scratchpad.empty {
    background-color: transparent;
  }

  #privacy {
    padding: 0;
  }

  #privacy-item {
    padding: 0 5px;
    color: white;
  }

  #privacy-item.screenshare {
    background-color: #cf5700;
  }

  #privacy-item.audio-in {
    background-color: #1ca000;
  }

  #privacy-item.audio-out {
    background-color: #0069d4;
  }
  '';
}
