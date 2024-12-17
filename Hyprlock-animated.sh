#!/bin/bash

#File name with extension
#By default the it's what convert.sh script generates (You can find it in utils)
FILE_NAME=output.webm

# Path to your file
#Also default path to the utils directory since that's where the file generates
FILE_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/Hyprlock-animated/utils/$FILE_NAME"

# Start mpv in a loop
mpv --fullscreen --no-audio --loop --no-osc "$FILE_PATH" &

# Get mpv process ID
MPV_PID=$!

# Run Hyprlock
hyprlock

# Once Hyprlock exits, stop VLC
kill $MPV_PID
