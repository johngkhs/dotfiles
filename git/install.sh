#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp -n "$script_dir/gitconfig" "$HOME/.gitconfig"
