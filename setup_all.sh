#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/usr/{bin,lib,include}"
mkdir -p "$HOME/usr/lib/python"

cd "$script_dir/git" && ./setup_git.sh
cd "$script_dir/tmux" && ./setup_tmux.sh
cd "$script_dir/powerline" && ./setup_powerline.sh
cd "$script_dir/zsh" && ./setup_zsh.sh
cd "$script_dir/vim" && ./setup_vim.sh
