#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/usr/bin"
mkdir -p "$HOME/usr/lib"
mkdir -p "$HOME/usr/include"

cd "$script_dir/tmux" && ./setup_tmux.sh
cd "$script_dir/zsh" && ./setup_zshrc.sh
cd "$script_dir/vim" && ./setup_vim.sh
