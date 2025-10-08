source "$CONFIG_DIR/icon_map_fn.sh"


# Load all icons on startup
IFS=$'\n'
for e in $(aerospace list-workspaces --all --format '%{workspace} %{workspace-is-focused}'); do
IFS=$' '
  ar=($e)
  sid=${ar[0]}
  focused=${ar[1]}
  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  icon_strip=" "
  drawing="on"
  if [ "${apps}" != "" ]; then
    while read -r app; do
      # remove non printable chars!!
      app=$(tr -dc '[[:print:]]' <<< "$app")
      icon=$(icon_map "$app")
      if [[ $icon_strip != *"$icon"* ]]; then
        icon_strip+="$icon "
      fi
      # # let's do just one icon per space for now!
      # break
    done <<<"${apps}"
  else
    icon_strip=""
    drawing="off"
    if [ "$focused" = "true" ]; then
      drawing="on"
    fi
  fi
  sketchybar --animate sin 10 --set space.$sid label="$icon_strip" drawing=$drawing
done
