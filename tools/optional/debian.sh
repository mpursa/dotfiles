#!/bin/sh
# Optional tools, for Debian: ~/dotfiles/tools/optional/debian.sh
set -e

# VS Code, from Microsoft's repo so apt upgrade keeps it current
sudo apt install -y curl gpg
curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft.gpg >/dev/null
printf '%s\n' 'Types: deb' 'URIs: https://packages.microsoft.com/repos/code' 'Suites: stable' 'Components: main' \
  'Architectures: amd64,arm64,armhf' 'Signed-By: /usr/share/keyrings/microsoft.gpg' \
  | sudo tee /etc/apt/sources.list.d/vscode.sources >/dev/null
sudo apt update
sudo apt install -y code
