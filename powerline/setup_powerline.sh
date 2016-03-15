#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

git clone https://github.com/powerline/powerline /tmp/powerline_src
cd /tmp/powerline_src && python setup.py install --home="$HOME/usr"
cp /tmp/powerline_src/scripts/powerline "$HOME/usr/bin"
rm -rf /tmp/powerline_src

git clone https://github.com/jaspernbrouwer/powerline-gitstatus /tmp/powerline_gitstatus_src
cd /tmp/powerline_gitstatus_src && python setup.py install --home="$HOME/usr"
rm -rf /tmp/powerline_gitstatus_src

echo '#!/usr/bin/env bash' > "$script_dir/source_powerline.zsh"
echo "source $(find $HOME/usr/lib/python -name powerline.zsh -print -quit)" >> "$script_dir/source_powerline.zsh"
chmod +x "$script_dir/source_powerline.zsh"
mkdir -p "$HOME/.config"
ln -s "$script_dir" "$HOME/.config/powerline"
