#!/bin/bash
set -e

ln -s /etc/nixos/configuration.nix ./${HOST}/configuration.nix
echo "Symlinked configuration.nix for ${HOST}"