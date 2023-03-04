#!/bin/bash
if ! command devbox 2>/dev/null; then
  curl -fsSL https://get.jetpack.io/devbox | bash
fi
devbox run init
