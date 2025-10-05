#!/bin/sh

source "$CONFIG_DIR/colors.sh"

if [ "$CHANGE_FOCUS" = "1" ]; then
  echo "Changing focus"
  source "$CONFIG_DIR/scripts/aerospace-icons.sh"
else
  if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on \
                          background.color=$ITEM_BG_COLOR \
                          background.corner_radius=8 \
                          label.color=$LABEL_COLOR \
                          icon.color=$LABEL_COLOR
  else
    sketchybar --set $NAME background.drawing=off \
                          label.color=$ACCENT_COLOR \
                          icon.color=$ACCENT_COLOR
  fi
fi
