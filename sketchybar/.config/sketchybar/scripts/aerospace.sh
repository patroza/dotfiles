#!/bin/sh

source "$CONFIG_DIR/colors.sh"

ws=$1

if [ "$CHANGE_FOCUS" = "1" ]; then
  source "$CONFIG_DIR/scripts/aerospace-icons.sh"
else
  if [ "$ws" = "$FOCUSED_WORKSPACE" ]; then
    # draw the background when the workspace is focused
    sketchybar --set $NAME background.drawing=on \
                          background.color=$ITEM_BG_COLOR \
                          background.corner_radius=8 \
                          label.color=$LABEL_COLOR \
                          icon.color=$LABEL_COLOR \
                          drawing="on"
  else
      # determine focused monitor by looking up $FOCUSED_WORKSPACE in list-workspaces
      workspaces=`aerospace list-workspaces --all --format '%{workspace} %{monitor-id}'`
      focused_monitor=$(echo "$workspaces" | awk -v fw="$FOCUSED_WORKSPACE" '$1==fw {print $2; exit}')
      workspace_monitor=$(echo "$workspaces" | awk -v ws="$ws" '$1==ws {print $2; exit}')

      # echo "focused monitor: $focused_monitor"
      # echo "workspace monitor: $workspace_monitor"

      # do not draw the workspace when there are no apps in it
      drawing="off"
      apps=$(aerospace list-windows --workspace "$ws" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')
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
