#!/usr/bin/env bash
set -o errexit -o nounset
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$HOME/.config/nvim
cp "$script_dir/init.lua" "$HOME/.config/nvim/init.lua"
