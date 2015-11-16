#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

ln -s "$(pwd)/tmux.conf" "$HOME/.tmux.conf"
