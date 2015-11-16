#!/usr/bin/env bash
set -e
mkdir -p zsh/plugins
git clone https://github.com/zsh-users/zsh-history-substring-search zsh/plugins/zsh-history-substring-search
ln -s "$(pwd)/zsh" "$HOME/.zsh"
ln -s "$(pwd)/zshrc" "$HOME/.zshrc"
