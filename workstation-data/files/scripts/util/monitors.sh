#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p bash
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/tags/25.11.tar.gz
set -u

find_monitor_position() {

    local FIND_ROW=$1
    local FIND_COL=$2

    #Reduce hyprctl input down to Name, resolution and position.
    local MONITORS=$(hyprctl monitors | awk '
        BEGIN { RS="Monitor " }
        NR>1 {
            name = $1
            split($4, resolution, "x")
            split($6, position, "x")
            sub(/@.*/, "", resolution[2])
            printf "%s %d %d %d %d\n", name, resolution[1], resolution[2], position[1], position[2]
        }')

    #Determine the bounds of the monitors.
    #Low X/Y, High X/Y
    local LX LY HX HY

    while read -r _ _ _ X Y; do
        [[ -z ${LX-} || X -lt LX ]] && LX=$X
        [[ -z ${LY-} || Y -lt LY ]] && LY=$Y
        [[ -z ${HX-} || X -gt HX ]] && HX=$X
        [[ -z ${HY-} || Y -gt HY ]] && HY=$Y
    done <<< "$MONITORS"

    # Determine the position of the monitors.
    # Name, resolution X/Y, posiiton X/Y
    while read -r NAME RX RY PX PY; do
        # Threshold X/Y = half resolution on axis.
        local TX=$(( $RX / 2 ))
        local TY=$(( $RY / 2 ))

        # Row/Horizontal position, Column/Vertical position 

        # Mental model is a 3x3 grid of monitors, most setups won't have a perfect rectangle
        #   But may use 1x3 or 3x1 or whatever.
        #   Noteworthy is that this doesn't support configurations greater than 3x3.
        #   R O W - >
        # C |------------|------------|------------|
        # O | Row left   | Row center | Row right  |
        # L | Col top    | Col top    | Col top    |
        #   |------------|------------|------------|
        # | | Row left   | Row center | Row right  |
        # v | Col center | Col center | Col center |
        #   |------------|------------|------------|
        #   | Row left   | Row center | Row right  |
        #   | Col bottom | Col bottom | Col bottom |
        #   |------------|------------|------------|
        local ROW=$(determine_axis_position "$PX" "$LX" "$HX" "$TX" left right)
        local COL=$(determine_axis_position "$PY" "$LY" "$HY" "$TY" top bottom)

        if [[ "$ROW" == "$FIND_ROW" && "$COL" == "$FIND_COL" ]]; then
            echo "$NAME $RX $RY $PX $PY row $ROW col $COL"
            return 0
        fi
    done <<< "$MONITORS"

    return 1
}

determine_axis_position() {
    local POSITION="$1"
    local LOWER_BOUND="$2"
    local UPPER_BOUND="$3"
    local THRESHOLD="$4"
    local NEGATIVE="$5"
    local POSITIVE="$6"
    local CENTER="center"

    local BOUND_LENGTH=$(( UPPER_BOUND - LOWER_BOUND ))

    if (( BOUND_LENGTH < THRESHOLD )); then
        echo "$CENTER"
    elif (( POSITION <= LOWER_BOUND + THRESHOLD )); then
        echo "$NEGATIVE"
    elif (( POSITION >= UPPER_BOUND - THRESHOLD )); then
        echo "$POSITIVE"
    else
        echo "$CENTER"
    fi
}


OPERATION="${1-}";

if [[ $OPERATION == "position" ]]; then

    if [[ $# -lt 3 ]]; then
        printf "ERROR: Missing arguments, pass desired location of the monitor like: './monitors.sh position center right' for example.\nPossible values are 'top', 'bottom', 'left', 'right' or 'center'."
        exit 2
    fi

    find_monitor_position "$2" "$3" || printf "No matches were found." >&2
else 
    echo "Invalid operation, pass one of the following arguments: position";
    exit 2
fi