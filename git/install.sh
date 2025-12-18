#!/usr/bin/env bash
set -o errexit -o nounset
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config/jj"
cp "$script_dir/jj/config.toml" "$HOME/.config/jj/config.toml"
cp "$script_dir/jj/cb" "$HOME/usr/bin"
cp "$script_dir/jj/ir" "$HOME/usr/bin"
cp "$script_dir/gitconfig" "$HOME/.gitconfig"
