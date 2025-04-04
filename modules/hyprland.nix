{ pkgs, lib, config, ... }:
let
	# waybar
	# nwg-dock-hyprland
	# kde-authentication
	# wofi
	# nautilus
	# kitty
	# chromium
	# rambox
  # hyprpicker
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;

	# TODO move to blade
	# blade_moditor = [
	# 	"eDP-1,highres,0x1080,1.6 # buildin display"
	# 	"DP-1,preferred,0x0,auto"
	# 	"DP-3,preferred,1920x0,auto"
	# 	",preferred,auto,auto"
	# ];
	pamixer = "${pkgs.pamixer}/bin/pamixer";
	brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
in
{
	imports = [
		./waybar
		./wofi.nix
	];

 #  home.packages = with pkgs; [
	# 	# numix-cursor-theme

 #    kdePackages.dolphin
	# ];

	programs.rofi = {
		package = pkgs.rofi-wayland;
		theme = "gruvbox-dark-hard";
	};

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

	# TODO move to blade
	gtk = {
    enable = true;
    theme = {
      name = "Orchis-Dark";
      package = pkgs.orchis-theme;
    };
    iconTheme = {
      name = "Tela-dark";
      package = pkgs.tela-icon-theme;
    };
  };
	qt = {
	  enable = true;
	  platformTheme = "gtk";
	};

	# Now symlink the `~/.config/gtk-4.0/` folder declaratively:
	# xdg.configFile = {
	#   "gtk-4.0/assets".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/assets";
	#   "gtk-4.0/gtk.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk.css";
	#   "gtk-4.0/gtk-dark.css".source = "${config.gtk.theme.package}/share/themes/${config.gtk.theme.name}/gtk-4.0/gtk-dark.css";
	# };

# 	xdg.configFile = { // this does not work for some reason?
# 		"electron-flags.conf".text = ''
# --enable-features=WaylandWindowDecorations
# --ozone-platform-hint=auto
# 		'';
# 		"electron13-flags.conf".text = ''
# --enable-features=UseOzonePlatform
# --ozone-platform=wayland		
# 		'';
# 	};

  wayland.windowManager.hyprland = {
    enable = true;
    package = lib.mkForce (lib.makeOverridable ({enableXWayland, enableNvidiaPatches}:
			wrappWithNixGL {inherit pkgs; pkg = pkgs.hyprland;}) {enableXWayland = true; enableNvidiaPatches = false;});
		systemd.enableXdgAutostart = true;
    settings = {
      # monitor = blade_moditor;
			exec-once = [
				"${config.programs.waybar.package}/bin/waybar"
				"nwg-dock-hyprland -d"
				"swww init"
				"/usr/lib/polkit-kde-authentication-agent-1"
				"hyprctl setcursor ${config.home.pointerCursor.name} 24"
				# "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2" # By default, the Nix package includes a patched wlroots that can render HiDPI XWayland windows.

				# "${pkgs.hypridle}/bin/hypridle"
				"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
			];
			xwayland = {
				force_zero_scaling = true;
			};
			env = [
				"XCURSOR_SIZE,24"
				# "GDK_SCALE,1.5"
				"NIXOS_OZONE_WL,1"
				"GTK_THEME,${config.gtk.theme.name}"
				"ELECTRON_OZONE_PLATFORM_HINT,auto"
				"GDK_BACKEND,wayland,x11,"
				"QT_QPA_PLATFORM,wayland;xcb"
				# "SDL_VIDEODRIVER,wayland"
				"CLUTTER_BACKEND,wayland"
				"XDG_CURRENT_DESKTOP,Hyprland"
				"XDG_SESSION_TYPE,wayland"
				"XDG_SESSION_DESKTOP,Hyprland"
				"QT_AUTO_SCREEN_SCALE_FACTOR,1"
				"QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
				# "QT_QPA_PLATFORMTHEME,qt5ct"
			];

      input = {
        kb_layout = "de";
        kb_variant = "neo_qwertz";
		    repeat_rate = 70;
		    repeat_delay = 180;

        follow_mouse = 1;
		    touchpad = {
		        natural_scroll = true;
		        disable_while_typing = false;
		        clickfinger_behavior = true;
		        scroll_factor = .5;
		    };

		    sensitivity = 0.1; # -1.0 - 1.0, 0 means no modification.
		    accel_profile = "flat";
      };
			gestures.workspace_swipe = true;

			# Style stuff
			# blurls = "waybar";
			layerrule = [
				"blur, waybar"
				"ignorealpha .3, waybar"
			];
      general = {
		    gaps_in = 5;
		    gaps_out = 12;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
		    layout = "dwindle";
				resize_on_border = true;
				allow_tearing = true;
      };
      decoration = {
        rounding = 12;

				shadow = {
					enabled = true;
	        range = 12;
	        render_power = 4;
	        offset = "0 1";
	        color = "rgba(00000090)";
				};

				blur = {
					enabled = true;
					size = 12;
					passes = 2;
					brightness = 1;
	        noise = 0.02;
	        contrast = 1;
	        popups = false;
	        popups_ignorealpha = 0.6;
				};
      };
      animations = {
        enabled = true;
        # TODO get more specific
		    bezier = [
					"easeOutQuad, 0.5, 1, 0.89, 1"
		    	"easeOutBack, 0.175, 0.885, 0.32, 1.275"
				];

		    animation = [
					"windows, 1, 3, easeOutQuad, popin 80%"
			    "windowsIn, 1, 3, easeOutBack"
			    "border, 1, 10, default"
			    "borderangle, 1, 8, default"
			    "fade, 1, 7, default"
			    "workspaces, 1, 5, default, slidefade 40%"
				];
      };
			windowrulev2 = [
				"float,class:org.telegram.desktop,title:^(Telegram)$"
				"float,class:Rambox"
				# "float,class:Godot"
				# "stayfocused,class:Godot"
				# "unset,class:Godot,title:^(.+)(Godot Engine)^(.+)"
				"tile,class:Godot,title:^(.+)(Godot Engine)^(.+)"
				"norounding, tag:original"
				"noborder, tag:original"
				"opaque, tag:original"
				"forcergbx, tag:original"
			];

			# TODO what does this do again?
			dwindle = {
		    pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
		    preserve_split = true; # you probably want this
				# no_gaps_when_only = 1;
			};
			# master.new_is_master = true;

			# Binds
			"$mod" = "SUPER";
      bind = [
				# User Programs
        "$mod, Q, exec, ${config.programs.kitty.package}/bin/kitty"
        # "$mod, W, exec, ${config.programs.chromium.package}/bin/chromium --ozone-platform-hint=auto"
        "$mod, W, exec, chromium"
        "$mod, E, exec, ${pkgs.nemo}/bin/nemo"
        # "$mod, X, hyprexpo:expo, toggle" # can be: toggle, off/disable or on/enable
				"$mod, u, exec, ${config.programs.kitty.package}/bin/kitty ~/Git/dotfiles/change.bash"
        "$mod, R, exec, ${config.programs.wofi.package}/bin/wofi --show drun"

				# System Programs
				"$mod SHIFT, L, exec, ${config.programs.swaylock.package}/bin/swaylock --show-failed-attempts --color 000000"

				# System shortcuts
        "$mod, C, killactive,"
        "$mod, V, togglefloating,"
				"$mod, T, togglesplit, "# dwindle
				"$mod, F, fullscreen,"
				"$mod, S, swapactiveworkspaces, 1 2"
				"$mod, m, exit, "

				# Alt tab cycling
				"ALT, Tab, cyclenext,"
				"ALT, Tab, bringactivetotop,"
				"ALT SHIFT, Tab, cyclenext, prev"
				"ALT SHIFT, Tab, bringactivetotop,"

				# Move focus with mod + arrow keys
				"$mod, left, movefocus, l"
				"$mod, right, movefocus, r"
				"$mod, up, movefocus, u"
				"$mod, down, movefocus, d"
				## Same with vim bindings
				"$mod, h, movefocus, l"
				"$mod, l, movefocus, r"
				"$mod, k, movefocus, u"
				"$mod, j, movefocus, d"

				# Switch workspaces with mainMod + [0-9]
				"$mod, 1, workspace, 1"
				"$mod, 2, workspace, 2"
				"$mod, 3, workspace, 3"
				"$mod, 4, workspace, 4"
				"$mod, 5, workspace, 5"
				"$mod, 6, workspace, 6"
				"$mod, 7, workspace, 7"
				"$mod, 8, workspace, 8"
				"$mod, 9, workspace, 9"
				"$mod, 0, workspace, 10"
				## Move active window to a workspace with mainMod + SHIFT + [0-9]
				"$mod SHIFT, 1, movetoworkspace, 1"
				"$mod SHIFT, 2, movetoworkspace, 2"
				"$mod SHIFT, 3, movetoworkspace, 3"
				"$mod SHIFT, 4, movetoworkspace, 4"
				"$mod SHIFT, 5, movetoworkspace, 5"
				"$mod SHIFT, 6, movetoworkspace, 6"
				"$mod SHIFT, 7, movetoworkspace, 7"
				"$mod SHIFT, 8, movetoworkspace, 8"
				"$mod SHIFT, 9, movetoworkspace, 9"
				"$mod SHIFT, 0, movetoworkspace, 10"

				# Scroll through existing workspaces with mainMod + scroll
				"$mod, mouse_down, workspace, e+1"
				"$mod, mouse_up, workspace, e-1"

				# Screenshot
				", PRINT, exec, hyprshot -m window"
				"SHIFT, PRINT, exec, hyprshot -m region"
				"$mod, PRINT, exec, hyprshot -m active -m window"
				"$mod SHIFT, S, exec, hyprshot -m output"

				"$mod, O, tagwindow, original"

      ];
      bindm = [
        # Mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
			bindl = [
				# Mute Mic
				", XF86AudioMicMute, exec, pamixer --default-source -m"

				# Media
				", XF86AudioMute, exec, pamixer -t"
				", XF86AudioPlay, exec, playerctl play-pause"
				", XF86AudioPause, exec, playerctl play-pause"
				", XF86AudioNext, exec, playerctl next"
				", XF86AudioPrev, exec, playerctl previous"
			];

			bindle = 
			[
				# Volume
				", XF86AudioRaiseVolume, exec, ${pamixer} -i 5 "
				", XF86AudioLowerVolume, exec, ${pamixer} -d 5 "
				
				# Screen brightness
				", XF86MonBrightnessUp, exec, ${brightnessctl} set +5%"
				", XF86MonBrightnessDown, exec, ${brightnessctl} set 5%-"
			];

			misc = {
				disable_hyprland_logo = true;
			};

			plugin = {
				hyprexpo = {
	        columns = 3; # so i can see all workspaces
	        gap_size = 24;
	        bg_col = "rgb(1d2021)";
	        workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1 # or center current
	        enable_gesture = true; # laptop touchpad, 4 fingers
	        gesture_distance = 250; # how far is the "max"
	        gesture_positive = true; # positive = swipe down. Negative = swipe up.
				};
			};
    };

		plugins = [
			# pkgs.hyprlandPlugins.hyprexpo
		];
  };

	# https://wiki.hyprland.org/Hypr-Ecosystem/hypridle/
  xdg.configFile."hypr/hypridle.conf".text = ''
		general {
		    lock_cmd = pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock		    before_sleep_cmd = loginctl lock-session
		    after_sleep_cmd = hyprctl dispatch dpms on
		}

		listener {
		    timeout = 300                                 # 5min
		    on-timeout = loginctl lock-session            # lock screen when timeout has passed
		}
  '';
}

# https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager
# https://github.com/hyprwm/contrib


# # home.nix
# {
#   wayland.windowManager.hyprland.settings = {
#     "$mod" = "SUPER";
#     bind =
#       [
#         "$mod, F, exec, firefox"
#         ", Print, exec, grimblast copy area"
#       ]
#       ++ (
#         # workspaces
#         # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
#         builtins.concatLists (builtins.genList (
#             x: let
#               ws = let
#                 c = (x + 1) / 10;
#               in
#                 builtins.toString (x + 1 - (c * 10));
#             in [
#               "$mod, ${ws}, workspace, ${toString (x + 1)}"
#               "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
#             ]
#           )
#           10)
#       );
#   };
# }
