#!/bin/sh
# Tools the dotfiles use, for Debian: ~/dotfiles/tools/debian.sh
set -e

sudo apt update
sudo apt install -y stow git git-lfs neovim tmux ripgrep bat fzf zoxide keychain fd-find gh curl

# starship is in apt from Debian 13 (trixie); older releases use the official installer
if apt-cache show starship >/dev/null 2>&1; then
  sudo apt install -y starship
else
  mkdir -p ~/.local/bin
  curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin
fi

# atuin: apt's is too old to load bash-preexec by itself
mkdir -p ~/.local/bin
curl --proto '=https' --tlsv1.2 -LsSf https://github.com/atuinsh/atuin/releases/latest/download/atuin-installer.sh | ATUIN_UNMANAGED_INSTALL="$HOME/.local/bin" sh

# fastfetch is in apt from Debian 13 (trixie)
if apt-cache show fastfetch >/dev/null 2>&1; then
  sudo apt install -y fastfetch
fi

# eza is in apt from Debian 13 (trixie)
if apt-cache show eza >/dev/null 2>&1; then
  sudo apt install -y eza
fi

# git-delta is in apt from Debian 13 (trixie)
if apt-cache show git-delta >/dev/null 2>&1; then
  sudo apt install -y git-delta
fi

# lazygit is in apt from Debian 13 (trixie)
if apt-cache show lazygit >/dev/null 2>&1; then
  sudo apt install -y lazygit
fi

# tmux plugin manager; press Ctrl-a I inside tmux to fetch the plugins
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
