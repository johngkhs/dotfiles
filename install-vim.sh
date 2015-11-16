#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

ln -s "$(pwd)/vimrc" "$HOME/.vimrc"
echo -e ":PluginInstall\n:qa" > /tmp/install_vim_plugins
vim -s /tmp/install_vim_plugins
rm /tmp/install_vim_plugins
