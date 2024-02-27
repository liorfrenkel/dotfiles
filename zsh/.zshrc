# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Aliases
alias vim="nvim"
alias v="nvim"
alias lg="lazygit"

# This should stay at the end
eval "$(zoxide init zsh)"
