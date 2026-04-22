# General shell aliases

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# List
alias ll='ls -la'
alias la='ls -A'

# NPM
alias nr='npm run'

# multipass
alias mp='multipass'

# Safety (uncomment if you want interactive rm)
# alias rm='rm -i'

# Edit config
alias zshconfig="${EDITOR:-vim} ~/.zshrc"
alias zshcustom="${EDITOR:-vim} ${ZSH_CUSTOM_DIR:-$HOME/.zsh.d}"

# Git (OMZ git plugin provides some; these override or supplement)
alias gst='git status'
alias gco='git checkout'
alias gp='git push'
alias gpl='git pull'

alias p='cd $HOME/Projects'
alias dev='cd $HOME/Projects/Development'

# Homebrew tools (conditional — only when command exists)
(( ${+commands[bat]} )) && alias cat='bat --paging=never'
(( ${+commands[lazygit]} )) && alias lg='lazygit'
(( ${+commands[btop]} )) && alias bt='btop'
(( ${+commands[htop]} )) && alias ht='htop'
(( ${+commands[prettyping]} )) && alias ping='prettyping'
(( ${+commands[kubectl]} )) && alias k='kubectl'
(( ${+commands[terraform]} )) && alias tf='terraform'
(( ${+commands[opentofu]} )) && alias tofu='opentofu'
# GitHub CLI (optional; skip if using OMZ gh plugin)
(( ${+commands[gh]} )) && alias ghpr='gh pr list' && alias ghprc='gh pr create'