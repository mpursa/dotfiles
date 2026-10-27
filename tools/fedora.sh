#!/bin/sh
# Tools the dotfiles use, for Fedora: ~/dotfiles/tools/fedora.sh
set -e

# curl comes with Fedora; asking for it can clash with curl-minimal
sudo dnf install -y stow git git-lfs neovim tmux ripgrep bat fzf

# starship isn't in Fedora's repos, so use the official installer
mkdir -p ~/.local/bin
curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin

# tmux plugin manager; press Ctrl-a I inside tmux to fetch the plugins
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
