#!/bin/sh
# Tools the dotfiles use, for Debian: ~/dotfiles/tools/debian.sh
set -e

sudo apt update
sudo apt install -y stow git git-lfs neovim tmux ripgrep bat fzf curl

# starship is in apt from Debian 13 (trixie); older releases use the official installer
if apt-cache show starship >/dev/null 2>&1; then
  sudo apt install -y starship
else
  mkdir -p ~/.local/bin
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin
fi

# fastfetch is in apt from Debian 13 (trixie)
if apt-cache show fastfetch >/dev/null 2>&1; then
  sudo apt install -y fastfetch
fi

# tmux plugin manager; press Ctrl-a I inside tmux to fetch the plugins
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
