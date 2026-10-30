# EDITOR=nvim would otherwise make zsh pick the vi keymap (no Ctrl-R search);
# set before compinit, which binds its widgets into the current keymap
bindkey -e

# history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE

export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/mpursa/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

# bun completions
[ -s "/Users/mpursa/.bun/_bun" ] && source "/Users/mpursa/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# chrome debugger alias
alias chrome-debug='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --remote-debugging-port=9222 --user-data-dir="$HOME/.chrome-debug-profile" &'

# ssh-add auth key
alias sshak='ssh-add --apple-use-keychain ~/.ssh/id_ed25519'

# symfony-lsp
export PATH="$HOME/.local/share/symfony-lsp:$PATH"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH=/opt/homebrew/opt/postgresql@18/bin:$PATH

# shared with Linux
if [ -f ~/.config/shell/common.sh ]; then
    source ~/.config/shell/common.sh
fi

# starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# fzf
[[ -t 0 ]] && command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

# atuin, after fzf so it gets Ctrl-R
command -v atuin >/dev/null 2>&1 && eval "$(atuin init zsh --disable-up-arrow --disable-ai)"

# zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# zsh-autosuggestions
[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# machine-specific, untracked: keep last so it can override
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
