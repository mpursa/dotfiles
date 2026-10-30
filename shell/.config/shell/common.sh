# Shared by zsh and bash

# PATH: personal scripts
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export EDITOR=nvim
export VISUAL=nvim

# ripgrep: rg errors on every run if this file is missing, so only set it once stowed
[ -f "$HOME/.config/ripgrep/config" ] && export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/config"

# delta
command -v delta >/dev/null 2>&1 && export GIT_PAGER=delta

# nvim
alias v='nvim'
alias vim='nvim'

# tmux
alias tm='tmux'
alias tma='tmux attach -t'
alias tmn='tmux new -s'
alias tman='tmux new -A -s'
alias tml='tmux ls'
alias tmk='tmux kill-session -t'

# symfony
if command -v symfony >/dev/null 2>&1; then
  alias sf='symfony console'
else
  alias sf='php bin/console'
fi
alias sfcc='sf cache:clear'
alias sfdr='sf debug:router'
alias sfme='sf make:entity'
alias sfps='sf server:start'
alias sfss='sf server:start'
alias sfssd='sf server:start -d'
alias sfsst='sf server:stop'

# Doctrine
alias domd='sf doctrine:migrations:diff'
alias dome-u='sf doctrine:migrations:execute --up'
alias dome-d='sf doctrine:migrations:execute --down'
alias domm='sf doctrine:migrations:migrate'
alias domm-n='sf doctrine:migrations:migrate --no-interaction'
alias domm-dry='sf doctrine:migrations:migrate --dry-run'
alias doms='sf doctrine:migrations:status'
alias dosv='sf doctrine:schema:validate'

# ls
alias ll='ls -lAh'

# Misc
alias h='history'
alias c='clear'
alias myip='curl -s ifconfig.me'
alias ff='fastfetch'
alias fetch='fastfetch'
alias grep='rg'
alias qq='exit'

# btop instead of top, where installed
command -v btop >/dev/null 2>&1 && alias top='btop'
# bduftop instead of df, where installed
command -v duf >/dev/null 2>&1 && alias df='duf'

# Debian installs bat as batcat
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  alias bat='batcat'
fi

# Debian installs fd as fdfind
if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  alias fd='fdfind'
fi

# fzf lists files with fd: hidden ones included, .gitignore respected
fd_bin=$(command -v fdfind || command -v fd)
if [ -n "$fd_bin" ]; then
  export FZF_DEFAULT_COMMAND="$fd_bin --type f --hidden --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
unset fd_bin

# cat through bat, only where bat is installed
if command -v bat >/dev/null 2>&1 || command -v batcat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

# clipboard
unalias clip 2>/dev/null
if [ -n "$SSH_TTY" ]; then
  # ssh case
  clip() { printf '\033]52;c;%s\a' "$(base64 | tr -d '\n')" >/dev/tty; }
elif [[ "$OSTYPE" == darwin* ]]; then
  alias clip='pbcopy'
else
  alias clip='wl-copy'
fi

# Command confirmation
_confirm() {
  local reply
  printf '%s %s? [y/N] ' "$1" "$(uname -n)"
  read -r reply
  [[ "$reply" == [yY]* ]]
}

if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
  alias ll='ls -lAGh'
  alias ports='lsof -iTCP -sTCP:LISTEN -n -P'
  # via System Events, so apps can save or cancel
  off() { _confirm 'Shut down' && osascript -e 'tell app "System Events" to shut down'; }
  restart() { _confirm 'Reboot' && osascript -e 'tell app "System Events" to restart'; }
else
  alias ls='ls --color=auto'
  alias ports='ss -tulpn'
  off() { _confirm 'Shut down' && sudo systemctl poweroff; }
  restart() { _confirm 'Reboot' && sudo systemctl reboot; }
fi

# reboot asks too
alias reboot='restart'

# eza where installed; ls stays ls, as some flags differ (ls -t)
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -la --git --group-directories-first --icons=auto'
  alias lt='eza --tree --level=2 --git-ignore --icons=auto'
fi

if [[ -n "$ZSH_VERSION" ]]; then
  alias reload='source ~/.zshrc'
else
  alias reload='source ~/.bashrc'
fi