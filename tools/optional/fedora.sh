#!/bin/sh
# Optional tools, for Fedora: ~/dotfiles/tools/optional/fedora.sh
set -e

# VS Code, from Microsoft's repo so dnf upgrade keeps it current
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
printf '%s\n' '[code]' 'name=Visual Studio Code' 'baseurl=https://packages.microsoft.com/yumrepos/vscode' \
  'enabled=1' 'autorefresh=1' 'type=rpm-md' 'gpgcheck=1' 'gpgkey=https://packages.microsoft.com/keys/microsoft.asc' \
  | sudo tee /etc/yum.repos.d/vscode.repo >/dev/null
sudo dnf install -y code
