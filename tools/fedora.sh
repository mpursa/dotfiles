#!/bin/sh
# Tools the dotfiles use, for Fedora: ~/dotfiles/tools/fedora.sh
set -e

# curl comes with Fedora; asking for it can clash with curl-minimal
sudo dnf install -y stow git git-lfs neovim tmux ripgrep bat fzf zoxide eza tealdeer keychain fd-find gh btop du-dust duf glow fastfetch git-delta wl-clipboard

# starship isn't in Fedora's repos, so use the official installer
mkdir -p ~/.local/bin
curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin

# atuin: dnf has it only in updates-testing
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh | ATUIN_UNMANAGED_INSTALL="$HOME/.local/bin" sh

# tmux plugin manager; press Ctrl-a I inside tmux to fetch the plugins
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
