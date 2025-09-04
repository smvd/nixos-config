{ config, pkgs, lib, ... }:

with lib;

{
	options = {
		smvd-desktop.enable = mkOption {
			type = types.bool;
			default = false;
			description = "Enable custom desktop setup";
		};

		smvd-desktop.batteryName = mkOption {
			type = types.str;
			default = "BAT0";
			description = "Name of the battery to be used in the status bar";
		};

		smvd-desktop.colors = mkOption {
			type = types.attrsOf types.str;  # an attribute set of strings
			default = {
				foreground = "#eeeeee";
				background = "#090b0c";
				accent-a   = "#40b5b5";
				accent-b   = "#2a7979";
				accent-c   = "#354046";
			};
			description = "Color scheme for custom desktop";
		};
	};

	config = mkIf config.smvd-desktop.enable {
		environment.systemPackages = [
			pkgs.swayfx
			pkgs.wlroots
			pkgs.foot
			pkgs.eww
			pkgs.rofi-wayland
			pkgs.firefox
			pkgs.brightnessctl
			pkgs.wpa_supplicant_gui
		];

		fonts = {
		  enableDefaultPackages = true;
		  packages = with pkgs; [
		  	spleen
		  	nerd-fonts.fira-code
		  	nerd-fonts.jetbrains-mono
		  ];
		  fontconfig.allowBitmaps = true;
		};

		environment.etc."sway/config".text = ''
			set $mod Mod1
			set $foreground ${config.smvd-desktop.colors.foreground}
			set $background ${config.smvd-desktop.colors.background}
			set $accent-a ${config.smvd-desktop.colors.accent-a}
			set $accent-b ${config.smvd-desktop.colors.accent-b}
			set $accent-c ${config.smvd-desktop.colors.accent-c}

			exec eww -c /etc/eww/ open bar
			exec /bin/sh /etc/eww/workspaces.sh
			
			output "*" bg ~/.config/wallpaper.svg fill
			
			font Spleen 6x12 Regular 12
			title_align center
			titlebar_separator disable
			default_border normal 20
			
			client.focused $accent-a $accent-a $background $background $background
			client.focused_inactive $accent-a $accent-a $background $background $background
			client.unfocused $background $background $foreground $background $background
			client.urgent $background $background $foreground $background $background
			client.placeholder $background $background $foreground $background $background
			
			gaps inner 10
			
			shadows enable
			shadow_blur_radius 8
			shadow_color #000000FF
			shadow_offset 2 2
			
			bindsym $mod+Shift+q kill
			bindsym $mod+Shift+r reload
			bindsym $mod+f fullscreen
			
			bindsym $mod+d 		exec rofi -show drun
			bindsym $mod+Return exec foot
			bindsym $mod+b      exec firefox
			
			bindsym $mod+Left 	focus left
			bindsym $mod+Down 	focus down
			bindsym $mod+Up 	focus up
			bindsym $mod+Right 	focus right
			
			bindsym $mod+Shift+Left move left
			bindsym $mod+Shift+Down move down
			bindsym $mod+Shift+Up move up
			bindsym $mod+Shift+Right move right
			
			bindsym $mod+1 workspace number 1
			bindsym $mod+2 workspace number 2
			bindsym $mod+3 workspace number 3
			bindsym $mod+4 workspace number 4
			bindsym $mod+5 workspace number 5
			bindsym $mod+6 workspace number 6
			    
			bindsym $mod+Shift+1 move container to workspace number 1
			bindsym $mod+Shift+2 move container to workspace number 2
			bindsym $mod+Shift+3 move container to workspace number 3
			bindsym $mod+Shift+4 move container to workspace number 4
			bindsym $mod+Shift+5 move container to workspace number 5
			bindsym $mod+Shift+6 move container to workspace number 6
		'';

		environment.etc."xdg/foot/foot.ini".text = ''
			font=Spleen 32x64:size=14

			[colors]
			background=${removePrefix "#" config.smvd-desktop.colors.background}
			foreground=${removePrefix "#" config.smvd-desktop.colors.foreground}
			regular7=bbbbbb
			bright7=${removePrefix "#" config.smvd-desktop.colors.foreground}
		'';

		environment.etc."eww/eww.yuck".text = ''
			(defvar workspace_1 "current")
			(defvar workspace_2 "used")
			(defvar workspace_3 "empty")
			(defvar workspace_4 "empty")
			(defvar workspace_5 "empty")
			(defvar workspace_6 "empty")

			(defpoll displayHeight
				:interval 	"1s"
				:run-while 	false
				:initial "1080"
				`swaymsg -t get_outputs | jq '.[0].current_mode.height'`)

			(defwidget workspace [id]
				(box
					:style {id == "current" ? "padding: 40px 1px;" : ""}
					:class "workspace ''\${id}-workspace"))

			(defwidget bar []
				(box
					:class "bar"
					:orientation "v"
							:height {displayHeight}
					(box
						:class "workspaces"
						:valign "start"
						:orientation "v"
						:space-evenly false
						(workspace :id workspace_1)
						(workspace :id workspace_2)
						(workspace :id workspace_3)
						(workspace :id workspace_4)
						(workspace :id workspace_5)
						(workspace :id workspace_6))
					(box
						:valign "end"
						:orientation "v"
						:space-evenly false
						(box
							:orientation "v"
							:space-evenly false
							(progress
								:class "battery-indicator"
								:flipped true
								:orientation "v"
								:height 120
								:value {EWW_BATTERY["${config.smvd-desktop.batteryName}"].capacity})
							(label
								:class "battery-icon"
								:text {EWW_BATTERY["${config.smvd-desktop.batteryName}"].status == "Discharging" ? "󰁹" : "󱐋"}))
						(label
							:class "clock"
							:angle 270
							:text {formattime(EWW_TIME, "%H.%M.%S", "Europe/Amsterdam")}))))

			(defwindow bar
				:monitor 0
				:stacking "fg"
				:exclusive true
				:geometry (geometry 
					:x "0px"
					:y "0px"
					:width "25px"
					:height "100%"
					:anchor "center right")
				(bar))
		'';

		environment.etc."eww/eww.scss".text = ''
			$foreground: ${config.smvd-desktop.colors.foreground};
			$background: ${config.smvd-desktop.colors.background};
			$accent-a: ${config.smvd-desktop.colors.accent-a};
			$accent-b: ${config.smvd-desktop.colors.accent-b};
			$accent-c: ${config.smvd-desktop.colors.accent-c};

			* {
				all: unset;
				color: $foreground;
				font-family: "Spleen 6x12";
				font-size: 16;
			}

			.bar {
				background-color: $background;
			}

			.clock {
				padding: 10px 0px;
			}

			.current-workspace {
				padding-top: 35px;
				background-color: $accent-a;
			}

			.used-workspace {
				background-color: $accent-b;
			}

			.empty-workspace {
				background-color: $accent-c;
			}

			.workspace {
				padding: 20px 1px;
				margin-bottom: 10px;
				border-radius: 5px;
				transition: padding 100ms; 
			}

			.workspaces {
				padding: 10px;
			}

			.battery-icon {
				padding-left: 4px;
				margin: 10px 0px;
			}

			.battery-indicator > trough {
				background-color: $accent-c;
				border-radius: 5px;
				margin-right: 7px;
				> progress {
					background-color: $accent-a;
					border-radius: 5px;
				}
			}
		'';

		environment.etc."eww/workspaces.sh".text = ''
			#!/bin/sh

			while true; do
				swaymsg -t subscribe '["workspace"]' >> /dev/null

				focused=$(swaymsg -r -t get_workspaces | jq -r '.[] | select(.focused == true) | .name')
				workspaces=$(swaymsg -r -t get_workspaces | jq -r '.[].name')

				for workspace in $(seq 1 6); do
				   if [ "$workspace" -eq "$focused" ]; then
				       eww -c /etc/eww update "workspace_$workspace=current"
				   elif echo "$workspaces" | grep -q "\b$workspace\b"; then
				       eww -c /etc/eww update "workspace_$workspace=used"
				   else
				       eww -c /etc/eww update "workspace_$workspace=empty"
				   fi
				done

				echo " "
			done
		'';
	};
}
