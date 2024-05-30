#!/bin/bash
set -e

if [[ -f $(cat /etc/hostname) ]]; then
  ln -s ./$(cat /etc/hostname)/configuration.nix /etc/nixos/configuration.nix
  echo "OK - Symlinked configuration.nix for $(cat /etc/hostname)"
else
  echo "FAIL - Unable to locate a configuration.nix for $(cat /etc/hostname)"
fi
