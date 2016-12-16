#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone https://github.com/VundleVim/Vundle.vim "$script_dir/dotvim/bundle/Vundle.vim"

ln -s "$script_dir/dotvim" "$HOME/.vim"
ln -s "$script_dir/vimrc" "$HOME/.vimrc"
