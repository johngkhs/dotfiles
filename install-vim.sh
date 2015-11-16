#!/usr/bin/env bash
set -e
ln -s "$(pwd)/vimrc" "$HOME/.vimrc"
echo -e ":PluginInstall\n:qa" > /tmp/install_vim_plugins
vim -s /tmp/install_vim_plugins
rm /tmp/install_vim_plugins
