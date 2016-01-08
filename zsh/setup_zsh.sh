#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

mkdir -p dotzsh/plugins
git clone https://github.com/zsh-users/zsh-history-substring-search dotzsh/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting dotzsh/plugins/zsh-syntax-highlighting
ln -s "$(pwd)/dotzsh" "$HOME/.zsh"
ln -s "$(pwd)/zshrc" "$HOME/.zshrc"
