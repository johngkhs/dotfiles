#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone https://github.com/VundleVim/Vundle.vim "$HOME/.vim/bundle/Vundle.vim"
cp -R -n "$script_dir/UltiSnips" "$HOME/.vim"
cp -n "$script_dir/vimrc" "$HOME/.vimrc"
