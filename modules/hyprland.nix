{ pkgs, lib, config, ... }:
let
	# waybar
	# nwg-dock-hyprland
	# kde-authentication
	# Vimix-cursors
	# wofi
	# nautilus
	# kitty
	# chromium
	# rambox
  wrappWithNixGL = import ../utils/wrapp-with-nix-gl.nix;

	# // TODO
	torpedo_monitor = [
    "eDP-1,preferred,auto,1"
    ",preferred,auto,auto"
  ];

	blade_moditor = [
		"eDP-1,highres,0x1080,1.6 # buildin display"
		"DP-1,preferred,0x0,auto"
		"DP-3,preferred,1920x0,auto"
		",preferred,auto,auto"
	];
in
{

	
  home.packages = with pkgs; [
		vimix-cursors
	];

  wayland.windowManager.hyprland = {
    enable = true;
    package = lib.mkForce (lib.makeOverridable ({enableXWayland, enableNvidiaPatches}: wrappWithNixGL pkgs pkgs.hyprland) {enableXWayland = true; enableNvidiaPatches = false;});
    settings = {
      monitor = blade_moditor;
			exec-once = [
				"waybar"
				"nwg-dock-hyprland -d"
				"swww init"
				"/usr/lib/polkit-kde-authentication-agent-1"
				"hyprctl setcursor Vimix-cursors 24"
				# "xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2" # By default, the Nix package includes a patched wlroots that can render HiDPI XWayland windows.
			];
			env = [
				"QT_QPA_PLATFORMTHEME,qt5ct"
				# "XCURSOR_SIZE,24"
				# "GDK_SCALE,2"
				"NIXOS_OZONE_WL,1"
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
			# gestures.workspace_swip = true;

			# Style stuff
      general = {
		    gaps_in = 5;
		    gaps_out = 18;
        border_size = 2;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
		    layout = "dwindle";
      };
      decoration = {
        rounding = 12;
        drop_shadow = true;
        shadow_range = 6;
        shadow_render_power = 2;
        # shadow_offset = "0 5";
        "col.shadow" = "rgba(1a1a1aee)";
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
				"float,class:Rambox,"
			];

			# TODO what does this do again?
			dwindle = {
		    pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
		    preserve_split = true; # you probably want this
			};
			master.new_is_master = true;

			# Binds
			"$mod" = "SUPER";
      bind = [
				# User shortcuts
        "$mod, Q, exec, ${config.programs.kitty.package}/bin/kitty"
        "$mod, W, exec, ${config.programs.chromium.package}/bin/chromium --ozone-platform-hint=auto\""
        "$mod, E, exec, ${pkgs.gnome.nautilus}/bin/nautilus -w"
        "$mod, X, exec, ${pkgs.rambox}/bin/rambox --no-sandbox"
				"$mod, u, exec, ${config.programs.kitty.package}/bin/kitty bash -c change"
        "$mod, R, exec, ${config.programs.rofi.package}/bin/rofi -show drun"

				# System shortcuts
        "$mod, C, killactive,"
        "$mod, V, togglefloating,"
				"$mod, T, togglesplit, "# dwindle
				"$mod, F, fullscreen,"
				"$mod, S, swapactiveworkspaces, 1 2"
				"$mod SHIFT, L, exec, swaylock -f -c 000000"
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

				# Screenshot a region
				"$mod, PRINT, exec, hyprshot -m region"
				"$mod SHIFT, S, exec, hyprshot -m region"
				# Screenshot a monitor
				", PRINT, exec, hyprshot -m output"
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

			bindle = [
				# Volume
				", XF86AudioRaiseVolume, exec, pamixer -i 5 "
				", XF86AudioLowerVolume, exec, pamixer -d 5 "
				
				# Screen brightness
				", XF86MonBrightnessUp, exec, brightnessctl set +5%"
				", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
			];

			misc = {
				disable_hyprland_logo = true;
			};
    };
  };
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
