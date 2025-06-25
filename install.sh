#!/bin/bash

# install devbox
if ! command devbox 2>/dev/null; then
  curl -fsSL https://get.jetpack.io/devbox | bash
fi

mkdir ~/devbox && cd $_

# install packages
devbox global pull https://raw.githubusercontent.com/jimmyhurrah/devbox/main/devbox.json
devbox global shellenv --recompute | source

# setup dotfiles
git init
git remote add origin https://github.com/jimmyhurrah/devbox.git
git fetch
git checkout -t origin/main -f
stow --verbose --dir=./dotfiles --target=$HOME --restow home

# Setup zsh as default shell
if command -v zsh &> /dev/null; then
    ZSH_PATH=$(command -v zsh)
    echo "Found zsh at: $ZSH_PATH"
    
    # Try chsh first (works on most systems)
    chsh -s "$ZSH_PATH" 2>/dev/null || \
    # Try usermod if chsh fails (requires sudo)
    sudo usermod -s "$ZSH_PATH" "$USER" 2>/dev/null || \
    echo "Note: Could not set zsh as default shell. Run 'sudo usermod -s $ZSH_PATH $USER' manually"
else
    echo "Warning: zsh not found after installation"
fi

echo "Setup complete! Open a new terminal to start using zsh, or run 'exec zsh' in your current session"
