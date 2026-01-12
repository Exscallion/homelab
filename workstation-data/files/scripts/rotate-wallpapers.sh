#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz

WALLPAPER_FILES=~/.files/wallpapers

#DAY_COUNT=$(date +%-j)
DAY_COUNT=2
WALLPAPER_COUNT=$(ls -l $WALLPAPER_FILES | grep ^d | wc -l)
WALLPAPER_INDEX=$(($DAY_COUNT % $WALLPAPER_COUNT + 1))
WALLPAPER_DIR=$(ls -d $WALLPAPER_FILES/* | sort | sed -n $WALLPAPER_INDEX"p")

# Uuuh this is not very resillient if you switch your cables around.
# Perhaps we should look into a more robust solution in sync with monitors.conf
# Could we manually parse the location perhaps?
LEFT_MONITOR="DP-1"
MIDDLE_MONITOR="HDMI-A-1"
RIGHT_MONITOR="DP-2"

FILL_FILE=$(ls $WALLPAPER_DIR | grep "fill")
LEFT_FILE=$(ls $WALLPAPER_DIR | grep "left")
MIDDLE_FILE=$(ls $WALLPAPER_DIR | grep "middle")
RIGHT_FILE=$(ls $WALLPAPER_DIR | grep "right")
SIDES_FILE=$(ls $WALLPAPER_DIR | grep "sides")

if [[ $LEFT_FILE ]]; then
  echo "Setting left monitor to $LEFT_FILE";
  swaybg -o $LEFT_MONITOR -i $WALLPAPER_DIR/$LEFT_FILE -m fill &
else 
  echo "Setting left monitor to $FILL_FILE";
  swaybg -o $LEFT_MONITOR -i $WALLPAPER_DIR/$FILL_FILE -m fill &
fi

if [[ $MIDDLE_FILE ]]; then
  echo "Setting middle monitor to $MIDDLE_FILE";
  swaybg -o $MIDDLE_MONITOR -i $WALLPAPER_DIR/$MIDDLE_FILE -m fill &
else 
  echo "Setting middle monitor to $FILL_FILE";
  swaybg -o $MIDDLE_MONITOR -i $WALLPAPER_DIR/$FILL_FILE -m fill &
fi

if [[ $RIGHT_FILE ]]; then
  echo "Setting right monitor (main) to $RIGHT_FILE";
  swaybg -o $RIGHT_MONITOR -i $WALLPAPER_DIR/$RIGHT_FILE -m fill &
else 
  echo "Setting right monitor (fill) to $FILL_FILE";
  swaybg -o $RIGHT_MONITOR -i $WALLPAPER_DIR/$FILL_FILE -m fill &
fi

# swaybg -o DP-1 -i "$WP_DP1" -m fill &
# swaybg -o DP-2 -i "$WP_DP2" -m fill &
# swaybg -o HDMI-1-A -i "$WP_HDMI1" -m fill &