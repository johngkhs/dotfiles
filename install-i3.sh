#!/usr/bin/env bash
set -e
if [ ! -d "$HOME/usr/bin" ]; then
  mkdir -p "$HOME/usr/bin"
fi
git clone https://github.com/johngkhs/i3-grid /tmp/i3-grid
cd /tmp/i3-grid
sh install.sh
rm -rf /tmp/i3-grid
ln -s "$(pwd)/i3" "$HOME/.i3"
