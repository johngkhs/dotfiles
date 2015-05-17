export PATH=$PATH:$HOME/bin
PATH=$PATH:$HOME/conf
PATH=$PATH:$HOME/scripts
PATH=$PATH:$HOME/local_things/bin
PATH=$PATH:$HOME/apache-ant-1.9.4/bin
PATH=$PATH:$HOME/R-install/bin
PATH=$HOME/CustomBin:$PATH
PATH=$PATH:$HOME/CustomInstall/llvm/build2/bin
PATH=$PATH:$HOME/CustomInstall/Bear-master-new/build/bear
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/CustomInstall/llvm/build2/lib
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/CustomInstall/libevent-2.0.22-stable/build/lib

export SVN_EDITOR=vim
source /opt/bjam-2013.1.55.0/enable
cs() { cd "$1" && ls -F --color; }
alias grep=/bin/grep
function grepIR() {
	grep -RIn --exclude=tags --exclude=cscope.files --exclude=cscope.out --exclude=cscope.po.out --exclude=cscope.in.out "$1" --exclude-dir=.svn --exclude-dir=bin .
}
function grepR() {
	grep -RIin --exclude=tags --exclude=cscope.files --exclude=cscope.out --exclude=cscope.po.out --exclude=cscope.in.out "$1" --exclude-dir=.svn --exclude-dir=bin .
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
    index=$(($1 - 2))
    less ${LAST_LL_FILES[$index]}
    R=${LAST_LL_FILES[$index]}
}

function v()
{
    index=$(($1 - 2))
    vim ${LAST_LL_FILES[$index]}
    R=${LAST_LL_FILES[$index]}
}

function s()
{
    index=$(($1 - 2))
    R=${LAST_LL_FILES[$index]}
}

function c()
{
    cd "$1"
    ls -FhA --color 
}

alias ls='ls -FhA --color'
alias d='dirs -v'
alias p='pushd'
alias o='popd'
alias bear='bear --libear /home/johkac/CustomInstall/Bear-master-new/libear/libear.so'

# define colors
C_DEFAULT="\[\033[m\]"
C_WHITE="\[\033[1m\]"
C_BLACK="\[\033[30m\]"
C_RED="\[\033[31m\]"
C_GREEN="\[\033[32m\]"
C_YELLOW="\[\033[33m\]"
C_BLUE="\[\033[34m\]"
C_PURPLE="\[\033[35m\]"
C_CYAN="\[\033[36m\]"
C_LIGHTGRAY="\[\033[37m\]"
C_DARKGRAY="\[\033[1;30m\]"
C_LIGHTRED="\[\033[1;31m\]"
C_LIGHTGREEN="\[\033[1;32m\]"
C_LIGHTYELLOW="\[\033[1;33m\]"
C_LIGHTBLUE="\[\033[1;34m\]"
C_LIGHTPURPLE="\[\033[1;35m\]"
C_LIGHTCYAN="\[\033[1;36m\]"
C_BG_BLACK="\[\033[40m\]"
C_BG_RED="\[\033[41m\]"
C_BG_GREEN="\[\033[42m\]"
C_BG_YELLOW="\[\033[43m\]"
C_BG_BLUE="\[\033[44m\]"
C_BG_PURPLE="\[\033[45m\]"
C_BG_CYAN="\[\033[46m\]"
C_BG_LIGHTGRAY="\[\033[47m\]"

export PS1="\n$C_LIGHTGREEN\u$C_DARKGRAY:$C_BLUE\w\n$C_DARKGRAY\$$C_DEFAULT "

alias tmux="TERM=screen-256color-bce tmux"
