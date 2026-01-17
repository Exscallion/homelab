#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz

#%f parameter from Thunar
DIR=$1

declare -A PROGRAMS=(
  ["Terminal (Kitty)"]="poes"
  ["IDE (Codium)"]="codium"
  ["Image Gallery"]="gallery"
)

choice="$(printf '%s\n' "${!PROGRAMS[@]}" \
  | wofi --dmenu -p "Which application do you want to open at $DIR")"

[[ -z $choice ]] && exit 0

PROGRAM=${PROGRAMS[$choice]}

case ${PROGRAMS[$choice]} in
    "poes")     kitty --directory $DIR ;;
    "codium")   codium $DIR            ;;
    "gallery")  swayimg --gallery $DIR ;;
esac


