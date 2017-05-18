#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone https://github.com/zsh-users/zsh-history-substring-search "$script_dir/dotzsh/plugins/zsh-history-substring-search"
git clone https://github.com/zdharma/fast-syntax-highlighting.git "$script_dir/dotzsh/plugins/fast-syntax-highlighting"
git clone https://github.com/seebi/dircolors-solarized.git "$script_dir/dotzsh/dircolors-solarized"
git clone https://github.com/clvv/fasd /tmp/fasd
cp /tmp/fasd/fasd "$HOME/usr/bin"
git clone https://github.com/wellle/tmux-complete.vim /tmp/tmux-complete
cp /tmp/tmux-complete/sh/tmuxcomplete "$HOME/usr/bin"
git clone https://github.com/robbyrussell/oh-my-zsh.git /tmp/oh-my-zsh
cp -R /tmp/oh-my-zsh/plugins/extract "$script_dir/dotzsh/plugins/extract"

cp -n "$script_dir/zshrc.shared" "$script_dir/zshrc"

platform="$(uname)"
if [[ "$platform" == *Darwin* ]]; then
    cat "$script_dir/zshrc.osx" >> "$script_dir/zshrc"
else
    cat "$script_dir/zshrc.linux" >> "$script_dir/zshrc"
fi

ln -s "$script_dir/dotzsh" "$HOME/.zsh"
ln -s "$script_dir/zshrc" "$HOME/.zshrc"
