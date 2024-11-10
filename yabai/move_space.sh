#!/bin/sh
# https://github.com/koekeishiya/yabai/wiki/Commands#message-passing-interface
# Forked from https://github.com/mikkelricky/grid-spaces/blob/main/navigate
set -eu

alias yabai='/opt/homebrew/bin/yabai'
alias jq='/opt/homebrew/bin/jq'

GRID_COLUMNS=3

grid_columns=${GRID_COLUMNS:-1}

number_of_spaces=$(yabai --message query --spaces | jq '. | length')
# Get 0-based index of focused space
focused_space=$(($(yabai --message query --spaces | jq '.[] | select(."has-focus" == true) | .index') - 1))

col=$((focused_space%grid_columns))
# row=$((focused_space/grid_columns))

target_space=$focused_space

move_window=false
direction=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --move-window)
      move_window=true
      shift
      ;;
    *)
      direction="$1"
      shift
      ;;
  esac
done

case "$direction" in
  "up")
    ((target_space-=grid_columns))
    ;;
  "down")
    ((target_space+=grid_columns))
    ;;
  "left")
    if [ "$col" -gt 0 ]; then
      ((target_space-=1))
    fi
    ;;
  "right")
    if [ "$col" -lt $((grid_columns - 1)) ]; then
      ((target_space+=1))
    fi
    ;;
esac

target_window=""

if [ "$target_space" -ne "$focused_space" ] && [ "$target_space" -ge 0 ] && [ "$target_space" -lt "$number_of_spaces" ]; then
  if "$move_window"; then
    target_window=$(yabai --message query --windows --window | jq '.id')

    # Move window to space (1-based)
    yabai --message window "$target_window" --space $((target_space + 1))
  fi

  # Set 1-based index of focused space
  yabai --message space --focus $((target_space + 1))

  if [ ! -z "$target_window" ]; then
    yabai --message window "$target_window" --focus
  fi

  # focused_space=$(($(yabai --message query --spaces | jq '.[] | select(."has-focus" == true) | .index') - 1))
  # col=$((focused_space%grid_columns))
  # row=$((focused_space/grid_columns))
  # osascript -e 'display notification "('$col', '$row')" with title "Spaces"'
fi
