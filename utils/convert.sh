#!/bin/bash

#Put the theme name you want the animation made from
NAME=

THEME_PATH="/usr/share/plymouth/themes/$NAME/"

OLDPWD=$PWD
cd $THEME_PATH

# Get current screen resolution dynamically
RESOLUTION=$(xrandr | grep -m 1 '*' | awk '{print $1}')
SCREEN_WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
SCREEN_HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2 | cut -d'+' -f1)

# Extract x from the .script file
x=$(cat "$NAME.script" | grep SetImage | awk '{print $3}')
x=${x:0:1}

# Calculate FPS using the formula 1 / (x / 50)
FPS=$(echo "scale=2; 1 / ($x / 50)" | bc)

# FFmpeg command to scale and pad to the user's resolution, using dynamic FPS
ffmpeg -framerate $FPS -i progress-%d.png \
-vf "pad=$SCREEN_WIDTH:$SCREEN_HEIGHT:($SCREEN_WIDTH-iw)/2:($SCREEN_HEIGHT-ih)/2:color=black" \
-c:v libvpx-vp9 -b:v 2M "$OLDPWD/output.webm"

cd $OLDPWD
