#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone https://github.com/zsh-users/zsh-history-substring-search "$script_dir/dotzsh/plugins/zsh-history-substring-search"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$script_dir/dotzsh/plugins/zsh-syntax-highlighting"
ln -s "$script_dir/dotzsh" "$HOME/.zsh"
ln -s "$script_dir/zshrc" "$HOME/.zshrc"
