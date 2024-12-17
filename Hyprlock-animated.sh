#!/bin/bash

#File name with extension
#By default the it's what convert.sh script generates (You can find it in utils)
FILE_NAME=output.webm

# Path to your file
#Also default path to the utils directory since that's where the file generates
FILE_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/Hyprlock-animated/utils/$FILE_NAME"

# Function to start mpv on each monitor
start_mpv_on_all_monitors() {
    MONITORS=$(hyprctl monitors | grep "Monitor" | awk '{print $2}')

    for MONITOR in $MONITORS; do
        # Start mpv on the current monitor
        hyprctl dispatch -- exec "[monitor $MONITOR]" mpv --fullscreen --no-audio --loop --no-osc "$FILE_PATH" &
        MPV_PIDS+=($!)  # Collect the process IDs of all mpv instances
    done
}

# Array to store mpv process IDs
MPV_PIDS=()

# Start mpv on all monitors
start_mpv_on_all_monitors

# Run Hyprlock
hyprlock
# Run Swaylock
#swaylock -c 00000022


# Once Hyprlock exits, stop all mpv instances
MPV_PIDS=$(ps -aux | grep "mpv --fullscreen" | awk '{print $2}')
for PID in $MPV_PIDS; do
    kill "$PID"
done

