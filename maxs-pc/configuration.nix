{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware.nix
      ./home.nix
      ./i3.nix
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

  environment.systemPackages = with pkgs; [
    wget
    btop
    killall
    moonlight-qt
  ];

  system.stateVersion = "23.11";
}

