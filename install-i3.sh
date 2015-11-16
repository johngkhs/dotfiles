#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

if [ ! -d "$HOME/usr/bin" ]; then
  mkdir -p "$HOME/usr/bin"
fi
git clone https://github.com/johngkhs/i3-grid /tmp/i3-grid
cd /tmp/i3-grid
bash install.sh
rm -rf /tmp/i3-grid
ln -s "$(pwd)/i3" "$HOME/.i3"
