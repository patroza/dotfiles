#!/bin/bash

# shellcheck disable=2086


##################################################
# More icalPal options

export ICALPAL="${ICALPAL} --cmd events --nrd --df %FT%T.%N%:z -o json"
export ICALPAL_CONFIG=
export TZ=/usr/share/zoneinfo/UTC


##################################################
# Set the environment

# Set the path to the awk script
SHADE="./scripts/shade.awk"

# Homebrew Ruby required
export PATH=/opt/homebrew/opt/ruby/bin:${PATH}


##################################################
# Style options

# Day header
day_style=(
    background.border_color="0xffffffff"
    background.border_width=1
    background.color="0xff000000"
    background.corner_radius=2

    icon.drawing=off

    label.background.height=30
    label.color="0xffffffff"
    label.font.size=15.0
    label.font.style=Bold
    label.padding_left=8
    label.width=300
)

# Events
event_style=(
    icon.font.style=Bold
    icon.padding_left=8
    icon.padding_right=8
    icon.width=68

    label.width=232
)

function formatDate {
  /usr/bin/osascript - "$1" <<END

  use framework "Foundation"

  on run {isoDate}
    set fmt to current application's NSDateFormatter's alloc()'s init()
    fmt's setDateFormat:"yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return (fmt's dateFromString:isoDate) as date as string
  end run

END
}

##################################################
# Add events to the popup

add_event() {
    # Extract the properties we want from the event
    TITLE=$(jq -r '.title' <<< "${EVENT}")
    SD=$(jq -r '.sdate' <<< "${EVENT}")
    AD=$(jq -r '.all_day' <<< "${EVENT}")
    COLOR=$(jq -r '.color' <<< "${EVENT}" | grep -Eio '[0-9A-F]{6}')

    # Split .sdate into date and time
    # hilarious..
    DATE=`formatDate "$SD" | sed 's/ at.*//'`
    TIME=$(echo $SD | cut -c 12-16)

    # Show day header only when it changes
    if [ "${DAY}" != "${DATE}" ]; then
	DAY="${DATE}"
	sketchybar --add item "${NAME}_d${N}" "popup.${NAME}" \
		   --set "${NAME}_d${N}" label="${DAY}" "${day_style[@]}"
    fi

    # Compute colors
    # The color from icalPal becomes options for awk
    # RRGGBB => "-v r=0xRR -v g=0xGG -v b=0xBB"
    RGB=$(sed -E 's/(..)(..)(..)/-v r=0x\1 -v g=0x\2 -v b=0x\3/' <<< "${COLOR}")
    BG=$(${SHADE} -v m=lighter ${RGB})
    FG=$(${SHADE} -v m=darker ${RGB})

    # Italicize all-day events
    if [ "${AD}" == "1" ]; then
	FONT=Italic
	TIME=
    else
	FONT=Regular
    fi

    # Add the event
    sketchybar --add item "${NAME}_p${N}" "popup.${NAME}" \
	       --set "${NAME}_p${N}" background.color="${BG}" \
	       --set "${NAME}_p${N}" icon="${TIME}" icon.color="${FG}" \
	       --set "${NAME}_p${N}" label="${TITLE}" label.color="${FG}" label.font.style=${FONT} \
	       --set "${NAME}_p${N}" "${event_style[@]}"


if [ "${first}" == "first" ]; then
   sketchybar --set "${NAME}" label="$(date "+%b %e") - ${TITLE}"
fi
}


##################################################
# Make the popup

make_popup() {
    first="first"
    "${EXE}" | jq -c 'sort_by(.sdate) | .[] | select((.sdate | fromrfc3339) > (now + (1 * 60 * 60)))' | while read -r EVENT; do
	add_event
    first=""
	((N++))
    done
}


##################################################
# Main

case "${SENDER}" in
    # Forced
    "forced")
	make_popup
	;;

    # Routine
    "routine")
	# Refresh the popup
	sketchybar --set "/${NAME}_/" drawing=off --remove "/${NAME}_/" \
		   --set "${NAME}" popup.drawing=off

	make_popup
	;;

    # Mouse clicked
    "mouse.clicked")
	# Toggle visibility of the popup
	sketchybar --set "${NAME}" popup.drawing=toggle
	;;

    # Mouse exited
    "mouse.exited.global" | "mouse.exited")
	# Hide the popup
	sketchybar --set "${NAME}" popup.drawing=off
	;;
esac