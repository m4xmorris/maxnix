#!/bin/bash
set -e

ln -s ./$(cat /etc/hostname)/configuration.nix /etc/nixos/configuration.nix
echo "Symlinked configuration.nix for $(cat /etc/hostname)"