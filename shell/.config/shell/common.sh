# Shared by zsh and bash

# PATH: personal scripts
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export EDITOR=nvim
export VISUAL=nvim

alias v='nvim'
alias vim='nvim'
alias tm='tmux new -A -s main'
alias ll='ls -lah'
alias gs='git status'
alias gl='git log --oneline --graph --decorate -20'

# Debian installs bat as batcat
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
fi
