{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  users.users.max = {
    shell = pkgs.zsh;
    initialPassword = "Changeme!234";
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
        autosuggestion.enable = true;
        initExtra = lib.mkDefault "touch .zshrc 2> /dev/null";
      };
      zsh.oh-my-zsh = {
        enable = true;
        theme = "risto";
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
