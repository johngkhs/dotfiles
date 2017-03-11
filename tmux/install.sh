#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp -n "$script_dir/tmux.shared.conf" "$script_dir/tmux.conf"

platform="$(uname)"
if [[ "$platform" == *Darwin* ]]; then
    cat "$script_dir/tmux.conf.osx" >> "$script_dir/tmux.conf"
else
    cat "$script_dir/tmux.conf.linux" >> "$script_dir/tmux.conf"
fi

ln -s "$script_dir/tmux.conf" "$HOME/.tmux.conf"
