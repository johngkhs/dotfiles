#!/usr/bin/env bash
set -o errexit -o nounset
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

[[ -d "$HOME/.zsh/plugins/zsh-history-substring-search" ]] || git clone https://github.com/zsh-users/zsh-history-substring-search "$HOME/.zsh/plugins/zsh-history-substring-search"
[[ -d  "$HOME/.zsh/plugins/fast-syntax-highlighting" ]] || git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$HOME/.zsh/plugins/fast-syntax-highlighting"
[[ -d  "$HOME/.zsh/dircolors-solarized" ]] || git clone https://github.com/seebi/dircolors-solarized.git "$HOME/.zsh/dircolors-solarized"
[[ -d  "$HOME/powerlevel10k" ]] || git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME/powerlevel10k"
[[ -d /tmp/fasd ]] || git clone https://github.com/clvv/fasd /tmp/fasd
cp /tmp/fasd/fasd "$HOME/usr/bin"
[[ -d /tmp/tmux-complete ]] || git clone https://github.com/wellle/tmux-complete.vim /tmp/tmux-complete
cp /tmp/tmux-complete/sh/tmuxcomplete "$HOME/usr/bin" && chmod +x "$HOME/usr/bin/tmuxcomplete"
[[ -d /tmp/oh-my-zsh ]] || git clone https://github.com/robbyrussell/oh-my-zsh.git /tmp/oh-my-zsh
cp -R /tmp/oh-my-zsh/plugins/extract "$HOME/.zsh/plugins/extract"

cp "$script_dir/zshrc.shared" "$HOME/.zshrc"
cp "$script_dir/p10k.zsh" "$HOME/.p10k.zsh"

platform="$(uname)"
if [[ "$platform" == *Darwin* ]]; then
    cat "$script_dir/zshrc.osx" >> "$HOME/.zshrc"
else
    cat "$script_dir/zshrc.linux" >> "$HOME/.zshrc"
fi
