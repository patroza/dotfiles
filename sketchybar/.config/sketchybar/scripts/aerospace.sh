#!/bin/sh

source "$CONFIG_DIR/colors.sh"

if [ "$CHANGE_FOCUS" = "1" ]; then
  source "$CONFIG_DIR/scripts/aerospace-icons.sh"
else
  if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    # draw the background when the workspace is focused
    sketchybar --set $NAME background.drawing=on \
                          background.color=$ITEM_BG_COLOR \
                          background.corner_radius=8 \
                          label.color=$LABEL_COLOR \
                          icon.color=$LABEL_COLOR \
                          drawing="on"
  else
      # determine focused monitor by looking up $FOCUSED_WORKSPACE in list-workspaces
      focused_monitor=$(aerospace list-workspaces --all --format '%{workspace} %{monitor-id}' | awk -v fw="$FOCUSED_WORKSPACE" '$1==fw {print $2; exit}')
      workspace_monitor=$(aerospace list-workspaces --all --format '%{workspace} %{monitor-id}' | awk -v ws="$1" '$1==ws {print $2; exit}')

      # do not draw the workspace when there are no apps in it
      drawing="off"
      apps=$(aerospace list-windows --workspace "$1" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
      if [ "${apps}" != "" ]; then
        drawing="on"
      fi

      # only remove the background when this workspace is on the same monitor as the focused workspace
      if [ -n "$workspace_monitor" ] && [ -n "$focused_monitor" ] && [ "$workspace_monitor" = "$focused_monitor" ]; then
      sketchybar --set $NAME background.drawing=off \
                            label.color=$ACCENT_COLOR \
                            icon.color=$ACCENT_COLOR \
                            drawing=$drawing
      fi

      sketchybar --set $NAME drawing=$drawing
  fi
fi
