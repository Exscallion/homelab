#!/bin/sh

#%f parameter from Thunar
DIR=$1

declare -A PROGRAMS=(
  ["Terminal (Kitty)"]="poes"
  ["IDE (Codium)"]="codium"
  ["Image Gallery"]="gallery"
)

choice="$(printf '%s\n' "${!PROGRAMS[@]}" \
  | wofi --dmenu -p "Which application do you want to open at $(pwd)")"

[[ -z $choice ]] && exit 0

PROGRAM=${PROGRAMS[$choice]}

case ${PROGRAMS[$choice]} in
    "poes")     kitty --directory $DIR ;;
    "codium")   codium $DIR            ;;
    "gallery")  swayimg --gallery $DIR ;;
esac


