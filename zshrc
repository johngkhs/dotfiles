export SVN_EDITOR=vim
PATH="$PATH:$HOME/usr/bin"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/usr/lib"

autoload -U colors && colors
function zle-line-init zle-keymap-select
{
    MODE="${${KEYMAP/vicmd/$bg[white]$fg[black]>>>}/(main|viins)/>>>}"
    PS1="$fg_bold[white]$bg[blue]%n@%m%{$reset_color%} $fg_bold[yellow]%~%{$reset_color%}${prompt_newline}${MODE}%{$reset_color%} "
    PS2="$PS1"
    zle reset-prompt
}

export HISTFILE="$HOME/.history"
export HISTSIZE=3000
export SAVEHIST=3000

zle -N zle-line-init
zle -N zle-keymap-select
setopt hist_ignore_all_dups
setopt inc_append_history
setopt share_history
setopt extendedglob
CDPATH=$CDPATH:/home/johkac/workspace_eclipse:/home/johkac/svnrepo/
autoload -U compinit && compinit
autoload -U promptinit && promptinit
zstyle ':completion:*' menu select=1
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'l:|=* r:|=*'
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:approximate:::' max-errors 1 numeric
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,command -w -w"
setopt menu_complete
unsetopt correct_all
bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey "^?" backward-delete-char

source /home/johkac/.zsh/plugins/substring-search/zsh-history-substring-search.zsh
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

cs() { cd "$1" && ls -F --color; }
alias grep=/bin/grep
function grepIR() {
	grep -RIn --exclude=tags --exclude=cscope.files --exclude=cscope.out --exclude=cscope.po.out --exclude=cscope.in.out "$1" --exclude-dir=.svn --exclude-dir=bin .
}
function grepR() {
	grep -RIin --exclude=compile_commands.json --exclude=tags --exclude=cscope.files --exclude=cscope.out --exclude=cscope.po.out --exclude=cscope.in.out "$1" --exclude-dir=.svn --exclude-dir=bin .
}
function grepcpp() {
    grep --include="*.cc" --include="*.h" --exclude-dir="bin" -rnP "$1" "$2"
}

function a()
{
    ls -FHAltr --color=always $1 | cat -n | awk -v n=5 '1; NR % n == 0 {print ""}' 
    LAST_LL_DIR=$1
    if [ -n "$LAST_LL_DIR" ]
    then
        LAST_LL_DIR="${LAST_LL_DIR%/}/"
    fi

    LAST_LL_FILES=()
    for filename in $(ls -FHAltr --color=never $LAST_LL_DIR | cat -n | awk '{ print $10 }')
    do
        LAST_LL_FILES+=("${LAST_LL_DIR}${filename}")
    done
}

function l()
{
    index=$(($1 - 1))
    less "${LAST_LL_FILES[$index]}"
    R=${LAST_LL_FILES[$index]}
}

function v()
{
    index=$(($1 - 1))
    vim "${LAST_LL_FILES[$index]}"
    R=${LAST_LL_FILES[$index]}
}

function s()
{
    index=$(($1 - 1))
    R=${LAST_LL_FILES[$index]}
}

function p()
{
    pushd +$1
}

function y()
{
    vim /home/johkac/log/tmux_panel.txt -c "normal! Gkk"
}

function x()
{
    xclip -out -selection clipboard
}

function svntrunk()
{
    svn info | grep '^URL' | awk '{print $NF}'
}

function svntag()
{
    trunk_url=$(svntrunk)
    echo ${trunk_url/trunk/tags}
}

function svntags()
{
    tags_url=$(svntag)
    svn ls -v $tags_url | sort -V
}

function svncopy()
{
    if [[ $# -ne 1 ]]; then
        echo "Usage: svncopy tag_name"
        return
    fi
    trunk_url=$(svntrunk)
    tag_url=$(svntag)
    svn copy "$trunk_url" "$tag_url/$1"
}

alias f='a /home/johkac/log'
alias ls='ls -FhA --color'
alias tmux="TERM=screen-256color-bce tmux"
alias xc='xclip -selection c'
