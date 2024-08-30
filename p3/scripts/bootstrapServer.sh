#!/usr/bin/env bash

echo "Bootstrap server"

sudo pacman --noconfirm -Sy docker
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
