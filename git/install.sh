#!/usr/bin/env bash
set -o errexit -o nounset


script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp "$script_dir/gitconfig" "$HOME/.gitconfig"
