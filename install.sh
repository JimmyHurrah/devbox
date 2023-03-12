#!/bin/bash
if ! command devbox 2>/dev/null; then
  curl -fsSL https://get.jetpack.io/devbox | bash
fi
devbox run init

pwsh -c install-module pure-pwsh 
pwsh -c install-module posh-git 
