#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone https://github.com/zsh-users/zsh-history-substring-search "$script_dir/dotzsh/plugins/zsh-history-substring-search"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$script_dir/dotzsh/plugins/zsh-syntax-highlighting"
git clone https://github.com/robbyrussell/oh-my-zsh.git /tmp/oh-my-zsh && cp -R /tmp/oh-my-zsh/plugins/extract "$script_dir/dotzsh/plugins/zsh-extract"

cp "$script_dir/shared.zshrc" "$script_dir/zshrc"

platform="$(uname)"
if [[ "$platform" == *Darwin* ]]; then
    cat "$script_dir/osx.zshrc" >> "$script_dir/zshrc"
else
    cat "$script_dir/linux.zshrc" >> "$script_dir/zshrc"
fi

ln -s "$script_dir/dotzsh" "$HOME/.zsh"
ln -s "$script_dir/zshrc" "$HOME/.zshrc"
