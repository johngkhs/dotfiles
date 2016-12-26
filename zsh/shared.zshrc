setopt interactive_comments

###############################################################################################################
#                                         environment variables                                               #
###############################################################################################################

export PATH="$HOME/usr/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/usr/lib:$LD_LIBRARY_PATH"
export PYTHONPATH="$HOME/usr/lib/python:$PYTHONPATH"
export EDITOR=vim

###############################################################################################################
#                                           general settings                                                  #
###############################################################################################################

autoload -U colors && colors
setopt extended_glob
unsetopt correct_all
export KEYTIMEOUT=10

###############################################################################################################
#                                               history                                                       #
###############################################################################################################

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=1000000
setopt append_history
setopt extended_history
setopt inc_append_history
setopt hist_ignore_all_dups
setopt share_history

###############################################################################################################
#                                            vim inner motions                                                #
###############################################################################################################

autoload -U select-quoted
autoload -U select-bracketed
zle -N select-quoted
zle -N select-bracketed

for mode in visual viopp; do
  for keymap in {a,i}{\',\",\`}; do
    bindkey -M "$mode" "$keymap" select-quoted
  done
done

for mode in visual viopp; do
  for keymap in {a,i}{\(,\),\[,\],\{,\},\<,\>,b,B}; do
    bindkey -M "$mode" "$keymap" select-bracketed
  done
done

###############################################################################################################
#                                               vim mode                                                      #
###############################################################################################################

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey "^?" backward-delete-char

###############################################################################################################
#                                            powerline prompt                                                 #
###############################################################################################################

source "$HOME/.config/powerline/source_powerline.zsh"
powerline-daemon -q

###############################################################################################################
#                                             tab completion                                                  #
###############################################################################################################

autoload -U compinit && compinit
setopt menu_complete
zmodload zsh/complist

zstyle ':completion:*' menu select=1
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:approximate:::' max-errors 1 numeric
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
zstyle ':completion:*:*:*:*:processes' command 'ps -u $USER -o pid,user,command -w -w'
zstyle ':completion:*' file-sort modification
bindkey -M menuselect '^[[Z' reverse-menu-complete

###############################################################################################################
#                                       zsh-history-substring-search                                          #
###############################################################################################################

source "$HOME/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up

###############################################################################################################
#                                         zsh-syntax-highlighting                                             #
###############################################################################################################

source "$HOME/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[path]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=white,underline'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=gray'

###############################################################################################################
#                                            zsh-extract                                                      #
###############################################################################################################

source "$HOME/.zsh/plugins/zsh-extract/extract.plugin.zsh"

###############################################################################################################
#                                               fzf                                                           #
###############################################################################################################

export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_OPTS="--reverse --bind=tab:down,btab:up"

###############################################################################################################
#                                             functions                                                       #
###############################################################################################################

c() {
  cd "$@" && fasd -A "$@";
}

k() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [[ "$pid" ]]
  then
    kill -${1:-15} "$pid"
  fi
}

d() {
  local dir
  dir="$(fasd -l -d | fzf +m)" && fasd -A "$dir" && cd "$dir"
}

d.() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) && fasd -A "$dir" && cd "$dir"
}

d/() {
  local dir
  dir="$(locate / | fzf +m)" && fasd -A "$dir" && cd "$dir"
}

v() {
  local file
  if [ $# -eq 0 ]
  then
        file="$(fasd -l -f | fzf +m)" && fasd -A "$file" && vim "$file"
  else
        vim "$@" && fasd -A "$@"
  fi
}

v/() {
  local file
  file="$(locate / | fzf +m)" && fasd -A "$file" && vim "$file"
}

v.() {
  local file
  file=$(fzf +m) && fasd -A "$file" && vim "$file"
}

h() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +m +s --tac -e | sed 's/ *[0-9]*[\* ]*//')
}

_fzf_branch() {
  local branches branch
  branches=$(git branch | grep -v HEAD) &&
  branch=$(echo "$branches" | fzf -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##"
}

db() {
  local branch
  branch="$(_fzf_branch)" && git branch -d "$branch"
}

br() {
  local branch
  branch="$(_fzf_branch)" && git checkout "$branch"
}

h.() {
  (ag -g ""; fasd -l) | fzf-tmux -d 90% +m
}

###############################################################################################################
#                                              aliases                                                        #
###############################################################################################################

alias g='git'
alias x='extract'
