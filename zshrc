PATH="$PATH:$HOME/usr/bin"
LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HOME/usr/lib"
EDITOR=vim

autoload -U compinit && compinit
autoload -U promptinit && promptinit
autoload -U colors && colors
autoload -U select-quoted
autoload -U select-bracketed

zle -N select-quoted
zle -N select-bracketed
zle -N zle-line-init
zle -N zle-keymap-select

setopt extendedglob
unsetopt correct_all

setopt menu_complete
zmodload zsh/complist

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=3000
export SAVEHIST=3000
setopt HIST_IGNORE_ALL_DUPS
setopt SHARE_HISTORY

for mode in visual viopp; do
  for keymap in {a,i}{\',\",\`}; do
    bindkey -M "$mode" "$keymap" select-quoted
  done
done

for mode in visual viopp; do
  for keymap in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M "$mode" "$keymap" select-bracketed
  done
done

function zle-line-init zle-keymap-select
{
  HIGHLIGHT="%{$bg[white]$fg[black]%}"
  VIM_MODE="${${KEYMAP/vicmd/$HIGHLIGHT>>>}/(main|viins)/>>>}"
  PS1="%{$fg_bold[white]$bg[blue]%}%n@%m%{$reset_color%} %{$fg_bold[yellow]%}%~%{$reset_color%}${prompt_newline}${VIM_MODE}%{$reset_color%} "
  zle reset-prompt
}

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

bindkey -v
bindkey -M viins 'jk' vi-cmd-mode
bindkey "^?" backward-delete-char

source "$HOME/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"
bindkey -M vicmd 'j' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up

alias y='vim /tmp/tmux_panel.txt -c "normal! Gkk"'
alias ls='ls -Fa'
alias tmux="TERM=screen-256color-bce tmux"
