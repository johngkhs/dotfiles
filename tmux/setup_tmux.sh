#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

platform="$(uname)"
cp "$script_dir/tmux.shared.conf" "$script_dir/tmux.conf"

if [[ "$platform" == *Darwin* ]]; then
    cat "$script_dir/tmux.osx.conf" >> "$script_dir/tmux.conf"
else
    cat "$script_dir/tmux.linux.conf" >> "$script_dir/tmux.conf"
fi

ln -s "$script_dir/tmux.conf" "$HOME/.tmux.conf"
