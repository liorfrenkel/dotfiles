# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# nvm
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# Temporarily fix it on home
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export PATH="$HOME/.local/bin:$PATH"

# Aliases
alias vim="nvim"
alias v="nvim"
alias nvimk="NVIM_APPNAME="nvim-kickstart" nvim"
alias lg="lazygit"

# This should stay at the end
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

. "$HOME/.local/bin/env"
