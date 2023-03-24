#!/bin/bash

# install devbox
if ! command devbox 2>/dev/null; then
  curl -fsSL https://get.jetpack.io/devbox | bash
fi

mkdir ~/devbox && cd $_

# install packages
curl https://raw.githubusercontent.com/jimmyhurrah/devbox/main/devbox.json > devbox.json
devbox run init

# setup dotfiles
git init
git remote add origin https://github.com/jimmyhurrah/devbox.git
git fetch
git checkout -t origin/main -f
devbox run dotfiles
