#!/usr/bin/env bash
set -o errexit -o nounset -o xtrace
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if command -v python3 >/dev/null 2>&1; then
    python_binary='python3'
else
    python_binary='python'
fi
export PYTHONPATH="$HOME/usr/lib/python:${PYTHONPATH-}"

[[ -d /tmp/powerline ]] || git clone https://github.com/powerline/powerline /tmp/powerline
cd /tmp/powerline
$python_binary setup.py install --home="$HOME/usr"
cp -n /tmp/powerline/scripts/powerline "$HOME/usr/bin"

[[ -d /tmp/powerline_gitstatus ]] || git clone https://github.com/jaspernbrouwer/powerline-gitstatus /tmp/powerline_gitstatus
cd /tmp/powerline_gitstatus
$python_binary setup.py install --home="$HOME/usr"

echo '#!/usr/bin/env bash' > "/tmp/source_powerline.zsh"
echo "source $(find $HOME/usr/lib/python -name powerline.zsh -print -quit)" >> "/tmp/source_powerline.zsh"
chmod +x "/tmp/source_powerline.zsh"

mkdir -p "$HOME/.config/powerline"
cp -n "/tmp/source_powerline.zsh" "$HOME/.config/powerline"
cp -R -n . "$HOME/.config/powerline"
