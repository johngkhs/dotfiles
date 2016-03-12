#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o xtrace

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pip install "powerline-status"
pip install "powerline-gitstatus"
echo '#!/usr/bin/env bash' > "$script_dir/source_powerline.zsh"
powerline_basepath=$(pip show "powerline-status" | grep "Location:" | awk '{print $2}')
echo "source $powerline_basepath/powerline/bindings/zsh/powerline.zsh" >> "$script_dir/source_powerline.zsh"
chmod +x "$script_dir/source_powerline.zsh"
mkdir -p "$HOME/.config"
ln -s "$script_dir" "$HOME/.config/powerline"
