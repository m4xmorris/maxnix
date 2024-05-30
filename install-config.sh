#!/bin/bash
set -e

CONFIG_PATH="$(cat /etc/hostname)/configuration.nix"

if [ -f ${CONFIG_PATH} ]; then
  ln -s ${CONFIG_PATH} /etc/nixos/configuration.nix
  echo "OK - Symlinked configuration.nix for $(cat /etc/hostname)"
else
  echo "FAIL - Unable to locate a configuration.nix for $(cat /etc/hostname)"
fi
