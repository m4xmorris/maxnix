{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{

  nixpkgs.config.allowUnfree = true;

  services.xserver = {
    enable = true;
	xkb.layout = "us";
    desktopManager.xterm.enable = false;
    displayManager.lightdm.enable = false;
    displayManager.startx.enable = true;
    windowManager.i3 = {
      enable = true;
    };
  };

  
  home-manager = {
    useGlobalPkgs = true;
	users.max = { 
	  pkgs, ... }: {
	    home.packages = [ 
		  pkgs.i3
		  pkgs.i3status-rust
		  pkgs.rofi
		  pkgs.rofi-screenshot
		  pkgs.i3lock
		  pkgs.picom
		  pkgs.dunst
		  pkgs.numlockx
		  pkgs.feh
		  pkgs.cinnamon.nemo
		  pkgs.playerctl
		  pkgs.firefox
		  pkgs.spotify
		  pkgs.terminator
		  pkgs._1password-gui
		  pkgs.pavucontrol
		  pkgs.vscode
		  pkgs.xorg.xinit
		  pkgs.xorg.xauth
		];
		xsession.enable = true;
		
		programs.vscode = {
		  enable = true;
		};

		programs.terminator = {
		  enable = true;
		  config = {
			profiles.default = {
				show_titlebar = false;
				background_type = "transparent";
				background_darkness = "0.75";
				font = "Ubuntu Mono 12";
				use_system_font = false;
				scrollback_lines = "2000";
				cursor_shape = "ibeam";
				scrollbar_position = "disabled";
				audible_bell = true;
				visual_bell = true;
			};
			keybindings = {
				zoom_in = "<Super>equal";
				zoom_out = "<Super>minus";
				zoom_normal = "<Super>BackSpace";
			};
		  };
		};

		programs.rofi = {
		  enable = true;
		  theme = "dracula";
		};
		
		programs.git.signing = {
		  signByDefault = true;
		  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3uxUvPAknwJHQWKg+B9AKnOW1ijkjGzq5IjuguW8rC";
		  gpgPath = "${pkgs._1password}/bin/op-ssh-sign";
		};

		home.file.rofi-dracula = {
		enable = true;
		text = builtins.readFile(builtins.fetchurl {
		url = "https://raw.githubusercontent.com/dracula/rofi/master/theme/config1.rasi";
		});
		target = ".config/rofi/dracula.rasi";
		};

		home.file.ssh-config = {
		  enable = true;
		  text = ''
		    Host *
	          IdentityAgent ~/.1password/agent.sock
		  '';
		  target = ".ssh/config";
		};

		programs.i3status-rust = {
		enable = true;
		bars = {
			top = {
			blocks = [
				{ block = "focused_window"; }
				{ block = "cpu"; }
				{ block = "memory"; }
				{ block = "battery"; }
				{ block = "disk_space"; }
				{ block = "music"; }
				{ block = "net"; }
				{ block = "sound"; }
				{ block = "temperature"; }
				{ block = "uptime"; }
				{ block = "time"; }
			];
			icons = "awesome5";
			theme = "dracula";
			};
		};
		};

		xsession = {
			windowManager.command = "${pkgs.i3}/bin/i3";
			scriptPath = ".xinitrc";
			windowManager.i3 = {
			enable = true;
			config = {
				modifier = "Mod4";
				window.titlebar = false;
				gaps.smartGaps = true;
				gaps.inner = 5;
				gaps.outer = 5;
				workspaceAutoBackAndForth = true;
				bars = [
				{
					fonts = { names = [ "Ubuntu Monospace" ]; size = 9.0; };

					colors = {
					background = "#282A36";
					statusline = "#F8F8F2";
					separator = "#44475A";
					focusedWorkspace = { border = "#44475A"; background = "#44475A"; text = "#F8F8F2"; };
					activeWorkspace = { border = "#282A36"; background = "#44475A"; text = "#F8F8F2"; };
					inactiveWorkspace = { border = "#282A36"; background = "#282A36"; text = "#BFBFBF"; };
					urgentWorkspace = { border = "#FF5555"; background = "#FF5555"; text = "#F8F8F2"; };
					bindingMode = { border = "#FF5555"; background = "#FF5555"; text = "#F8F8F2"; };
					};

					position = "top";
					trayOutput = "primary";
					statusCommand = "i3status-rs /home/max/.config/i3status-rust/config-top.toml";
				}
				];
				startup = [
				{ command = "numlockx on"; always = true; }
				{ command = "feh --bg-fill /home/max/Pictures/wallpaper.jpg"; always = true; }
				{ command = "solaar -w hide"; }
				{ command = "nextcloud"; }
				{ command = "dunst"; }
				{ command = "picom" ; }
				];

				keybindings = let modifier = config.home-manager.users.max.xsession.windowManager.i3.config.modifier;
				in lib.mkForce {
				# Restart i3
				"${modifier}+Shift+r" = "restart"; # Reload i3 config
				"${modifier}+Shift+c" = "reload";

				# Quit i3
				"${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Exit i3?' -b 'yes' 'i3-msg exit'";

				# Media Keys
				"XF86AudioPlay" = "exec playerctl play-pause";
				"XF86AudioNext" = "exec playerctl next";
				"XF86AudioPrev" = "exec playerctl previous";
				"XF86AudioRaiseVolume" = "exec amixer sset 'Master' 5%+";
				"XF86AudioLowerVolume" = "exec amixer sset 'Master' 5%-";
				"XF86AudioMute" = "exec amixer sset 'Master' toggle";

				# Switch Workspaces
				"${modifier}+0" = "workspace number 10";
				"${modifier}+1" = "workspace number 1";
				"${modifier}+2" = "workspace number 2";
				"${modifier}+3" = "workspace number 3";
				"${modifier}+4" = "workspace number 4";
				"${modifier}+5" = "workspace number 5";
				"${modifier}+6" = "workspace number 6";
				"${modifier}+7" = "workspace number 7";
				"${modifier}+8" = "workspace number 8";
				"${modifier}+9" = "workspace number 9";

				# Change focused window
				"${modifier}+Down" = "focus down";
				"${modifier}+Left" = "focus left";
				"${modifier}+Right" = "focus right";
				"${modifier}+Up" = "focus up";

				# Move focused window
				"${modifier}+Shift+Down" = "move down";
				"${modifier}+Shift+Left" = "move left";
				"${modifier}+Shift+Right" = "move right";
				"${modifier}+Shift+Up" = "move up";

				# Fullscreen the focused window
				"${modifier}+Return" = "fullscreen toggle";
		
				# Rofi
				"${modifier}+space" = "exec --no-startup-id rofi -show drun -show-icons";
				"${modifier}+s" = "exec --no-startup-id 'rofi -show ssh -terminal \"terminator\"  -ssh-command \"{terminal} -e \\\"{ssh-client} {host} [-p {port}] ; read\\\"\"'";

				# Media keys
				"${modifier}+a" = "exec playerctl previous";
				"${modifier}+d" = "exec playerctl next";

				# Make the focused window float
				"${modifier}+Shift+f" = "floating toggle";

				# Tile in horizontal orientation
				"${modifier}+h" = "split h";

				# Launch Firefox & switch to its workspace
				"${modifier}+i" = "exec --no-startup-id firefox & i3 workspace 2";

				# Lock Screen
				"${modifier}+l" = "exec \"betterlockscreen -l\"";

				# Kill the focused window
				"${modifier}+q" = "kill";

				# Launch Terminator
				"${modifier}+t" = "exec --no-startup-id terminator & i3 workspace 1";

				# Tile in vertical orientation
				"${modifier}+v" = "split v";

				# Screenshot to clipboard
				"${modifier}+Shift+s" = "exec --no-startup-id rofi-screenshot";

				# Resize the focused window
				"${modifier}+r" = "mode \"resize\"";
			};
		  };
		};
	  };
	};
  };
}
