#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

ln -s "$(pwd)/tmux.macos.conf" "$HOME/.tmux.macos.conf"
ln -s "$(pwd)/tmux.linux.conf" "$HOME/.tmux.linux.conf"
ln -s "$(pwd)/tmux.conf" "$HOME/.tmux.conf"
