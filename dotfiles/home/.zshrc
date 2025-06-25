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

# Disable bell sounds
setopt NO_BEEP

# Fish-like features - install minimal plugins
# Download plugins if they don't exist
if [[ ! -d ~/.zsh-plugins ]]; then
    mkdir -p ~/.zsh-plugins
fi

if [[ ! -d ~/.zsh-plugins/zsh-autosuggestions ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh-plugins/zsh-autosuggestions
fi

if [[ ! -d ~/.zsh-plugins/zsh-syntax-highlighting ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh-plugins/zsh-syntax-highlighting
fi

if [[ ! -d ~/.zsh-plugins/zsh-history-substring-search ]]; then
    git clone https://github.com/zsh-users/zsh-history-substring-search ~/.zsh-plugins/zsh-history-substring-search
fi

# Load plugins
source ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh-plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # Must be last

# Configure history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

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