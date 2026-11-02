#!/bin/sh
# Tools the dotfiles use, for Arch: ~/dotfiles/tools/arch.sh
set -e

sudo pacman -Syu --needed --noconfirm stow git git-lfs neovim tmux ripgrep bat fzf zoxide eza tealdeer keychain fd github-cli btop dust duf glow fastfetch git-delta lazygit starship atuin lazydocker yazi wl-clipboard curl
sudo pacman -S --needed --noconfirm ffmpeg 7zip jq poppler imagemagick resvg

# tmux plugin manager; press Ctrl-a I inside tmux to fetch the plugins
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
