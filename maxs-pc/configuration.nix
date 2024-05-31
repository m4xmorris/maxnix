{ config, lib, pkgs, ... }:
{
  imports =
    [
      ../modules/update-maxnix/update-maxnix.nix
      ./hardware.nix
      ../modules/home/home.nix
      ../modules/i3/i3.nix
    ];

  nixpkgs.config.allowUnfree = true;

  users.users.max.extraGroups = [ "wheel" ];

  networking.hostName = "maxs-pc";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true;
  };

  home-manager.users.max.xsession.windowManager.i3.config.bars = [
    {
      tray_output = "DP2"; 
    }
  ];

  environment.systemPackages = with pkgs; [
    wget
    btop
    killall
    moonlight-qt
    spotify
  ];

  system.stateVersion = "23.11";
}
