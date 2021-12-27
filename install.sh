#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "This install script will overwrite your local dotfiles. Continue?"
select user_input in "Yes" "No"; do
    case $user_input in
        Yes ) break;;
        No ) echo "Aborted install";  exit;;
    esac
done

mkdir -p $HOME/usr/{bin,lib,include}

cd "$script_dir/git" && ./install.sh
cd "$script_dir/tmux" && ./install.sh
cd "$script_dir/zsh" && ./install.sh
cd "$script_dir/vim" && ./install.sh
echo "Dotfile installation complete."
echo "Verify bat, tmux, vim, rg, and fzf are installed."
