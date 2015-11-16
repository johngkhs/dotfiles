PATH="$PATH:$HOME/usr/bin"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/usr/lib"
source "$HOME/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

function a()
{
    [ "$#" -gt 1 ] && { echo "Usage: $0 [DIRECTORY]" >&2; return 1 }
    local target_dir="$(pwd)"
    if [ $# -eq 1 ]; then
      target_dir="$1"
    fi
    target_dir="${target_dir%/}/"
    [ ! -d "$target_dir" ] && { echo "Error: $target_dir does not exist" >&2; return 1 }
    ls -FHAltr "$target_dir" | cat -n | awk -v n=5 '1; NR % n == 0 {print ""}'

    LIST_OF_TARGET_FILES=()
    for filename in $(ls -FHAltr "$target_dir" | cat -n | awk '{ print $10 }')
    do
        LIST_OF_TARGET_FILES+=("${target_dir}${filename}")
    done
}

function l()
{
    [ "$#" -ne 1 ] && { echo "Usage: $0 index" >&2; return 1}
    local target_index="$(($1 - 1))"
    R="${LIST_OF_TARGET_FILES[$target_index]}"
    less "$R"
}

function v()
{
    [ "$#" -ne 1 ] && { echo "Usage: $0 index" >&2; return 1}
    local target_index="$(($1 - 1))"
    R="${LIST_OF_TARGET_FILES[$target_index]}"
    vim "$R"
}

function s()
{
    [ "$#" -ne 1 ] && { echo "Usage: $0 index" >&2; return 1}
    local target_index="$(($1 - 1))"
    R="${LIST_OF_TARGET_FILES[$target_index]}"
}

function y()
{
    vim /tmp/tmux_panel.txt -c "normal! Gkk"
}

alias ls='ls -FhA --color'
alias tmux="TERM=screen-256color-bce tmux"
alias xc='xclip -selection c'
