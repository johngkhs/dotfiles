#!/usr/bin/env bash
set -o errexit -o nounset
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "This install script will overwrite your local dotfiles. Continue?"
select user_input in "Yes" "No"; do
    case $user_input in
        Yes ) break;;
        No ) echo "Aborted install";  exit 1;;
    esac
done

command -v git || (echo "Failed to install. You must install git first."; exit 1;)
command -v wget || (echo "Failed to install. You must install wget first."; exit 1;)

mkdir -p $HOME/usr/{bin,lib,include}

cd "$script_dir/git" && ./install.sh
cd "$script_dir/tmux" && ./install.sh
cd "$script_dir/zsh" && ./install.sh
cd "$script_dir/vim" && ./install.sh
echo "Dotfile installation complete."
echo "You will also need to install bat, fzf, tmux, rg, vim, zsh, and a powerline font."
