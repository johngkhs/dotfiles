#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

ln -s "$(pwd)/vimrc" "$HOME/.vimrc"
git clone https://github.com/VundleVim/Vundle.vim dotvim/bundle/Vundle.vim
ln -s "$(pwd)/dotvim" "$HOME/.vim"
