# Shared by zsh and bash

# PATH: personal scripts
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export EDITOR=nvim
export VISUAL=nvim

# nvim
alias v='nvim'
alias vim='nvim'

# tmux
alias tm='tmux'
alias tma='tmux new -A -s main'
alias tml='tmux ls'
alias tk='tmux kill-session -t'

# ls
alias ll='ls -lAh'

# Misc
alias h='history'
alias c='clear'
alias myip='curl -s ifconfig.me'

# Debian installs bat as batcat
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
fi

if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
  alias ll='ls -lAGh'
  alias ports='lsof -iTCP -sTCP:LISTEN -n -P'
else
  alias ls='ls --color=auto'
  alias ports='ss -tulpn'
fi

if [[ -n "$ZSH_VERSION" ]]; then
  alias reload='source ~/.zshrc'
else
  alias reload='source ~/.bashrc'
fi