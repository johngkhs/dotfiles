#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone https://github.com/VundleVim/Vundle.vim "$script_dir/dotvim/bundle/Vundle.vim"

ln -s "$script_dir/gitconfig" "$HOME/.gitconfig"
