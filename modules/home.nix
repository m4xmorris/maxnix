{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  users.users.max = {
	shell = pkgs.zsh;
	ignoreShellProgramCheck = true;
    isNormalUser = true;
  };

  fonts.packages = with pkgs; [
    font-awesome
    powerline-fonts
    powerline-symbols
    ubuntu_font_family
  ];

  home-manager = {
    useGlobalPkgs = true;
    users.max = { 
    pkgs, ... }: {
        home.stateVersion = "23.11";
        home.packages = [ 
          pkgs.zsh
          pkgs.vim
          pkgs.speedtest-cli
          pkgs.fastfetch
          pkgs.btop
          pkgs.git
          pkgs._1password
        ];

    programs = {
      zsh = {
        enable = true;
        syntaxHighlighting.enable = true;
        enableAutosuggestions = true;
	shellAliases = { update-maxnix = "sudo rm -r /etc/nixos && sudo git clone https://github.com/m4xmorris/maxnix /etc/nixos && sudo bash /etc/nixos/install-config.sh"; };
        initExtra = "touch .zshrc 2> /dev/null ; if [ $TTY = \"/dev/tty1\" ] && [[ $HOST = maxs-pc || $HOST = maxs-laptop ]] ; then ; startx; exit ;fi";
      };
      zsh.oh-my-zsh = {
        enable = true;
        theme = "jonathan";
      };
      git = {
        enable = true;
        userName = "Maxwell Morris";
        userEmail = "git@maxmorris.io";
      };
    };

    home.sessionVariables = {
      EDITOR = "vim";
      SUDO_PROMPT = "[⚡ sudo on $(cat /etc/hostname) for $USER]:";
    };

    };
  };
}
