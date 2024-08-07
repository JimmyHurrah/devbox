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

# change shell to fish
chsh -s $(which fish)
