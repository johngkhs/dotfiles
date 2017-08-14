#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p $HOME/usr/{bin,lib,include}
mkdir -p $HOME/usr/lib/python

cd "$script_dir/git" && ./install.sh
cd "$script_dir/tmux" && ./install.sh
cd "$script_dir/powerline" && ./install.sh
cd "$script_dir/zsh" && ./install.sh
cd "$script_dir/vim" && ./install.sh
