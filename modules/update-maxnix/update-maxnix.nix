{ config, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [git];
    shellAliases = { update-maxnix = "sudo rm -r /etc/nixos && sudo git clone https://github.com/m4xmorris/maxnix /etc/nixos && sudo bash /etc/nixos/modules/update-maxnix/install-config.sh"; };
  };
}
