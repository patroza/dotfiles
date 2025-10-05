source "$CONFIG_DIR/icon_map_fn.sh"


# Load all icons on startup
for sid in $(aerospace list-workspaces --all); do
  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  sketchybar --set space.$sid drawing=on

  icon_strip=" "
  if [ "${apps}" != "" ]; then
    while read -r app; do
      # remove non printable chars!!
      app=$(tr -dc '[[:print:]]' <<< "$app")
      icon=$(icon_map "$app")
      icon_strip+="$icon "
      # # let's do just one icon per space for now!
      # break
    done <<<"${apps}"
  else
    icon_strip=" —"
  fi
  sketchybar --animate sin 10 --set space.$sid label="$icon_strip"
done
