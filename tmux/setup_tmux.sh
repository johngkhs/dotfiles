#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp -n "$script_dir/shared.tmux.conf" "$script_dir/tmux.conf"

platform="$(uname)"
if [[ "$platform" == *Darwin* ]]; then
    cat "$script_dir/osx.tmux.conf" >> "$script_dir/tmux.conf"
else
    cat "$script_dir/linux.tmux.conf" >> "$script_dir/tmux.conf"
fi

ln -s "$script_dir/tmux.conf" "$HOME/.tmux.conf"
