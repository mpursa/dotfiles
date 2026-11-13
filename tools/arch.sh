#!/bin/sh
# Tools the dotfiles use, for Arch: ~/dotfiles/tools/arch.sh
set -e

sudo pacman -Syu --needed --noconfirm stow git git-lfs neovim tmux ripgrep bat fzf zoxide eza tealdeer keychain fd github-cli btop dust duf glow fastfetch git-delta lazygit starship atuin lazydocker yazi wl-clipboard curl
sudo pacman -S --needed --noconfirm ffmpeg 7zip jq poppler imagemagick resvg

# ble.sh: autosuggestions and syntax highlighting for bash
curl -fsSL https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz | tar xJf - -C /tmp
bash /tmp/ble-nightly/ble.sh --install ~/.local/share
rm -rf /tmp/ble-nightly

# tmux plugin manager; press Ctrl-a I inside tmux to fetch the plugins
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
