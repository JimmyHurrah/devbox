# Minimal ZSH Configuration for fish-like experience

# Source devbox environment - simplified approach
if command -v devbox &> /dev/null; then
    export PATH="/root/.local/share/devbox/global/default/.devbox/nix/profile/default/bin:$PATH"
    export DEVBOX_PACKAGES_DIR="/root/.local/share/devbox/global/default/.devbox/nix/profile/default"
fi

# History settings (fish-like behavior)
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Enable vim mode
bindkey -v
export KEYTIMEOUT=1

# Fish-like history search (prefix matching)
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# Disable bell sounds
setopt NO_BEEP

# Load antidote and plugins
export ANTIDOTE_DIR="$DEVBOX_PACKAGES_DIR/share/antidote"
source "$ANTIDOTE_DIR/antidote.zsh"
antidote load

# Modern CLI tools (fish-like aliases)
alias cat="bat -n"
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first"
alias tree="eza --tree --icons"

# Git aliases
alias gd="git diff"
alias gs="git status"
alias gl="git log --oneline --graph"

# Initialize tools
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh --cmd cd)"
fi

if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
fi

# Starship prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

# Better CD with auto-ls
cd() {
    builtin cd "$@" && ls
}

# FZF improvements
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/*"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='find . -type d -not -path "*/\.git/*" 2>/dev/null'

export PATH="$HOME/.npm-global/bin:$PATH"

eval "$(devbox global shellenv)"
eval "$(zoxide init zsh --cmd cd)"

