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
          pkgs.betterlockscreen
          pkgs.picom
          pkgs.dunst
          pkgs.numlockx
          pkgs.feh
          pkgs.cinnamon.nemo
          pkgs.playerctl
          pkgs.firefox
          pkgs.discord
          pkgs.terminator
          pkgs._1password-gui
          pkgs.pavucontrol
          pkgs.vscode
          pkgs.xorg.xinit
          pkgs.xorg.xauth
          pkgs.brightnessctl
        ];
        xsession.enable = true;

        programs = {
          vscode = {
            enable = true;
          };

          terminator = {
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

          rofi = {
            enable = true;
            theme = "dracula";
          };
      
          i3status-rust = {
            enable = true;
            bars = {
              top = {
                blocks = [
                  { block = "focused_window"; format = " $title.str |"; }
                  { block = "cpu"; format = "  $utilization "; }
                  { block = "memory"; format = "  $mem_used.eng(prefix:Mi)/$mem_total.eng(prefix:Mi)($mem_used_percents.eng(w:2)) "; }
                  { block = "battery"; }
                  { block = "disk_space"; format = "  $available "; }
                  { block = "music"; format = "🎵 {$combo.str(max_w:25,rot_interval:0.5) $play |}"; }
                  { block = "net"; }
                  { block = "sound"; }
                  { block = "temperature"; format = " $icon $max C "; }
                  { block = "uptime"; }
                  { block = "time"; }
                ];
                icons = "awesome6";
                theme = "dracula";
              };
            };
          };

          zsh = {
            initExtra = "if [ $TTY = \"/dev/tty1\" ] && [[ $HOST = maxs-pc || $HOST = maxs-laptop ]] ; then ; startx; exit ;fi; touch .zshrc 2> /dev/null";
            shellAliases = { update-lockscreen = "betterlockscreen -u /etc/nixos/modules/i3/wallpaper.jpg"; };
          };

          firefox = {
            enable = true;
            profiles.default = {
              isDefault = true;
              search = {
                default = "Google";
                force = true;
              };
              settings = {
                "browser.startup.homepage" = "https://google.co.uk";
                "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
              };
            };
          };

        };

        home = {
          file.ssh-config = {
            enable = true;
            text = ''
              Host *
                IdentityAgent ~/.1password/agent.sock
            '';
            target = ".ssh/config";
          };

          file.rofi-dracula = {
            enable = true;
            text = builtins.readFile(builtins.fetchurl {
              url = "https://raw.githubusercontent.com/dracula/rofi/master/theme/config1.rasi";
            });
            target = ".config/rofi/dracula.rasi";
          };

          file.gitconfig = {
            enable = true;
            text = ''
              [user]
              signingkey = ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE3uxUvPAknwJHQWKg+B9AKnOW1ijkjGzq5IjuguW8rC
              [gpg]
              format = ssh
              [gpg "ssh"]
              program = "/home/max/.nix-profile/bin/op-ssh-sign"
              [commit]
              gpgsign = true
            '';
            target = ".gitconfig";
          };
        };

        services.screen-locker = {
          enable = true;
          inactiveInterval = 10;
          lockCmd = "${pkgs.betterlockscreen}/bin/betterlockscreen -l dimblur";
          xautolock = {
            enable = true;
            detectSleep = true;
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
              gaps.smartGaps = false;
              gaps.inner = 3;
              gaps.outer = 2;
              workspaceAutoBackAndForth = true;
              defaultWorkspace = "workspace number 1";
                bars = [
                  {
                    fonts = { names = [ "Ubuntu" ]; size = 9.0; };
                    position = "top";
                    trayOutput = "primary";
                    statusCommand = "i3status-rs /home/max/.config/i3status-rust/config-top.toml";
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
                  }
                ];
                startup = [
                  { command = "numlockx on"; always = true; }
                  { command = "feh --bg-fill /etc/nixos/modules/i3/wallpaper.jpg"; always = true; }
                  { command = "solaar -w hide"; }
                  { command = "nextcloud"; }
                  { command = "dunst"; }
                  { command = "picom" ; }
                  { command = "1password --silent"; }
                  { command = "discord --start-minimized"; }
                  { command = "blueman-applet"; }
                ];

                keybindings = let modifier = config.home-manager.users.max.xsession.windowManager.i3.config.modifier;
                in lib.mkForce {
                  # Restart i3
                  "${modifier}+Shift+r" = "restart"; # Restart i3

                  # Quit i3
                  "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Exit i3?' -b 'yes' 'i3-msg exit'";

                  # Media Keys
                  "XF86AudioPlay" = "exec playerctl play-pause";
                  "XF86AudioNext" = "exec playerctl next";
                  "XF86AudioPrev" = "exec playerctl previous";
                  "XF86AudioRaiseVolume" = "exec amixer sset 'Master' 5%+";
                  "XF86AudioLowerVolume" = "exec amixer sset 'Master' 5%-";
                  "XF86AudioMute" = "exec amixer sset 'Master' toggle";

                  # Brightness Keys
                  "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +15%";
                  "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 15%-";

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

                  # Move focused window to a workspace
                  "${modifier}+Shift+1" = "move container to workspace number 1 ; workspace number 1";
                  "${modifier}+Shift+2" = "move container to workspace number 2 ; workspace number 2";
                  "${modifier}+Shift+3" = "move container to workspace number 3 ; workspace number 3";
                  "${modifier}+Shift+4" = "move container to workspace number 4 ; workspace number 4";
                  "${modifier}+Shift+5" = "move container to workspace number 5 ; workspace number 5";
                  "${modifier}+Shift+6" = "move container to workspace number 6 ; workspace number 6";
                  "${modifier}+Shift+7" = "move container to workspace number 7 ; workspace number 7";
                  "${modifier}+Shift+8" = "move container to workspace number 8 ; workspace number 8";
                  "${modifier}+Shift+9" = "move container to workspace number 9 ; workspace number 9";
                  "${modifier}+Shift+0" = "move container to workspace number 10 ; workspace number 10";
                  
                  # Move workspaces between monitors
                  "${modifier}+Ctrl+Left" = "move workspace to output left";
                  "${modifier}+Ctrl+Right" = "move workspace to output right";


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

                  # Make the focused window float
                  "${modifier}+Shift+f" = "floating toggle";

                  # Tile in horizontal orientation
                  "${modifier}+h" = "split h";

                  # Tile in vertical orientation
                  "${modifier}+v" = "split v";

                  # Launch Firefox & switch to its workspace
                  "${modifier}+i" = "exec --no-startup-id firefox";

                  # Lock Screen
                  "${modifier}+l" = "exec ${pkgs.betterlockscreen}/bin/betterlockscreen -l dimblur";

                  # Kill the focused window
                  "${modifier}+q" = "kill";

                  # Launch Terminator
                  "${modifier}+t" = "exec --no-startup-id terminator";

                  # Screenshot
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
