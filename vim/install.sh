#!/usr/bin/env bash
set -o errexit -o nounset
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -d "$HOME/.vim/bundle/Vundle.vim" ]] || git clone https://github.com/VundleVim/Vundle.vim "$HOME/.vim/bundle/Vundle.vim"
cp "$script_dir/vimrc" "$HOME/.vimrc"
cp "$script_dir/ideavimrc" "$HOME/.ideavimrc"
