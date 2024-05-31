#!/bin/bash
set -e

CONFIG_PATH="/etc/nixos/$(cat /etc/hostname)/configuration.nix"

if [ -f ${CONFIG_PATH} ]; then
  ln -s ${CONFIG_PATH} /etc/nixos/configuration.nix
  echo -e "\nOK - Symlinked configuration.nix for $(cat /etc/hostname)"
  read -p "Rebuild now (N/s/b)?" REBUILD
  if [ "${REBUILD}" == "s" ];then
    echo
    nixos-rebuild switch
  elif [ "${REBUILD}" == "b" ]; then
    echo
    nixos-rebuild boot
  fi
else
  echo -e "\nFAIL - Unable to locate a configuration.nix for $(cat /etc/hostname)"
fi
