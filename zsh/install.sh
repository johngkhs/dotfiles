#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -d "$HOME/.zsh/plugins/zsh-history-substring-search" ]] || git clone https://github.com/zsh-users/zsh-history-substring-search "$HOME/.zsh/plugins/zsh-history-substring-search"
[[ -d  "$HOME/.zsh/plugins/fast-syntax-highlighting" ]] || git clone https://github.com/zdharma/fast-syntax-highlighting.git "$HOME/.zsh/plugins/fast-syntax-highlighting"
[[ -d  "$HOME/.zsh/dircolors-solarized" ]] || git clone https://github.com/seebi/dircolors-solarized.git "$HOME/.zsh/dircolors-solarized"
[[ -d /tmp/fasd ]] || git clone https://github.com/clvv/fasd /tmp/fasd
cp /tmp/fasd/fasd "$HOME/usr/bin"
[[ -d /tmp/tmux-complete ]] || git clone https://github.com/wellle/tmux-complete.vim /tmp/tmux-complete
cp /tmp/tmux-complete/sh/tmuxcomplete "$HOME/usr/bin"
[[ -d /tmp/oh-my-zsh ]] || git clone https://github.com/robbyrussell/oh-my-zsh.git /tmp/oh-my-zsh
cp -R /tmp/oh-my-zsh/plugins/extract "$HOME/.zsh/plugins/extract"

curl -o "$HOME/usr/bin/diff-so-fancy" https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
chmod +x "$HOME/usr/bin/diff-so-fancy"
curl -o "$HOME/usr/bin/tldr" https://raw.githubusercontent.com/raylee/tldr/master/tldr
chmod +x "$HOME/usr/bin/tldr"

cp "$script_dir/zshrc.shared" "$HOME/.zshrc"

platform="$(uname)"
if [[ "$platform" == *Darwin* ]]; then
    cat "$script_dir/zshrc.osx" >> "$HOME/.zshrc"
else
    cat "$script_dir/zshrc.linux" >> "$HOME/.zshrc"
fi
