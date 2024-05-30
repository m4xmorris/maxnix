{ config, ... }:
{
  environment.shellAliases = {
    update-config = "sudo rm -r /etc/nixos && sudo git clone https://github.com/m4xmorris/maxnix /etc/nixos && sudo bash /etc/nixos/install-config.sh";
  };
}
