# EDITOR=nvim would otherwise make zsh pick the vi keymap (no Ctrl-R search);
# set before compinit, which binds its widgets into the current keymap
bindkey -e

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

# symfony-lsp
export PATH="$HOME/.local/share/symfony-lsp:$PATH"

export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

export PATH=/opt/homebrew/opt/postgresql@18/bin:$PATH

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# shared with Linux
if [ -f ~/.config/shell/common.sh ]; then
    source ~/.config/shell/common.sh
fi

# starship prompt
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# machine-specific, untracked: keep last so it can override
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi

[ -f ~/.config/shell/common.sh ] && source ~/.config/shell/common.sh
