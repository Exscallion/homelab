#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz

LOG_FILES=~/.files/logs
WALLPAPER_FILES=~/.files/wallpapers

DAY_COUNT=$(date +%-j)
WALLPAPER_COUNT=$(ls -l $WALLPAPER_FILES | grep ^d | wc -l)
WALLPAPER_INDEX=$(($DAY_COUNT % $WALLPAPER_COUNT + 1))
WALLPAPER_DIR=$(ls -d $WALLPAPER_FILES/* | shuf --random-source=<(echo 8008135) | sed -n $WALLPAPER_INDEX"p")

LEFT_MONITOR="DP-1"
CENTER_MONITOR="HDMI-A-1"
RIGHT_MONITOR="DP-2"

set_wallpaper() {
  local DIR=$1
  local POSITION=$2
  local MONITOR=$3

  FILE=$(ls $WALLPAPER_DIR | grep $POSITION)
  FILL_FILE=$(ls $WALLPAPER_DIR | grep "fill")

  if [[ "$FILE" ]]; then
    echo "Setting $POSITION monitor (main) to $FILE";
    nohup swaybg -o $MONITOR -i $DIR/$FILE -m fill 2>&1 &
    echo
  else 
    echo "Setting $POSITION monitor (fill) to $FILL_FILE";
    nohup swaybg -o $MONITOR -i $DIR/$FILL_FILE -m fill 2>&1 &
    echo
  fi
}

# Kill previous instances 
pkill swaybg

{
  echo
  echo "===> Wallpaper change output from $(date '+%Y-%m-%d %H:%M:%S')"
  set_wallpaper "$WALLPAPER_DIR" "left" "$LEFT_MONITOR"
  set_wallpaper "$WALLPAPER_DIR" "center" "$CENTER_MONITOR"
  set_wallpaper "$WALLPAPER_DIR" "right" "$RIGHT_MONITOR"
} >> "$LOG_FILES/wallpaper.log" &

