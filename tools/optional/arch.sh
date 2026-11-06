#!/bin/sh
# Optional tools, for Arch: ~/dotfiles/tools/optional/arch.sh
set -e

# VS Code: Microsoft's build is only in the AUR, so build it with makepkg; rerun to update
sudo pacman -S --needed --noconfirm base-devel git
build=$(mktemp -d)
trap 'rm -rf "$build"' EXIT
git clone --depth 1 https://aur.archlinux.org/visual-studio-code-bin.git "$build"
(cd "$build" && makepkg -si --needed --noconfirm)
