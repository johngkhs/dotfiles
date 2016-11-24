#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PYTHONPATH="$HOME/usr/lib/python:${PYTHONPATH-}"
git clone https://github.com/powerline/powerline /tmp/powerline
cd /tmp/powerline
python setup.py install --home="$HOME/usr"
cp -n /tmp/powerline/scripts/powerline "$HOME/usr/bin"

git clone https://github.com/jaspernbrouwer/powerline-gitstatus /tmp/powerline_gitstatus
cd /tmp/powerline_gitstatus
python setup.py install --home="$HOME/usr"

echo '#!/usr/bin/env bash' > "$script_dir/source_powerline.zsh"
echo "source $(find $HOME/usr/lib/python -name powerline.zsh -print -quit)" >> "$script_dir/source_powerline.zsh"
chmod +x "$script_dir/source_powerline.zsh"
mkdir -p "$HOME/.config"

ln -s "$script_dir" "$HOME/.config/powerline"
