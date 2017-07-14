#!/bin/bash
USAGE="usage: $0 (own|own_plus_dual|external_triple) [nvidia|intel]"
LAYOUT="$1"
DRIVER="$2"

# Guess driver if not supplied
if [[ -z "$DRIVER" ]] ; then
    glxinfo | grep "vendor string: NVIDIA"
    if [[ "$?" == "0" ]] ; then
        DRIVER=nvidia
    else
        DRIVER=intel
    fi
    echo "Guessed driver: $DRIVER"
fi

# Symbolic names for xrandr outputs, based on my home setup
# TODO: handle direct output from laptop, also other adapters?
case "$DRIVER" in
    nvidia)
        OUTPUT_OWN=eDP-1-1
        OUTPUT_LEFT=DP-1-1-2
        OUTPUT_CENTRE=DP-1-2-1
        OUTPUT_RIGHT=DP-1-2-2
        ;;
    intel)
        OUTPUT_OWN=eDP-1
        OUTPUT_LEFT=DP-1-2
        OUTPUT_CENTRE=DP-2-1
        OUTPUT_RIGHT=DP-2-2
        ;;
    *)
        echo "$USAGE"
        exit 1
esac

# xrandr layouts based on the symbolic output names
case "$LAYOUT" in
    own)
        XRANDR="
        --output $OUTPUT_OWN --auto --primary
        --output $OUTPUT_LEFT --off
        --output $OUTPUT_CENTRE --off
        --output $OUTPUT_RIGHT --off
        "
        PANEL_ON=""     # "automatic"
        ;;
    own_plus_dual)
        XRANDR="
        --output $OUTPUT_OWN --auto
        --output $OUTPUT_LEFT --auto --primary --above $OUTPUT_OWN
        --output $OUTPUT_CENTRE --auto --right-of $OUTPUT_LEFT
        --output $OUTPUT_RIGHT --off
        "
        PANEL_ON=""     # "automatic"
        ;;
    external_triple)
        XRANDR="
        --output $OUTPUT_OWN --off
        --output $OUTPUT_LEFT --auto
        --output $OUTPUT_CENTRE --auto --primary --right-of $OUTPUT_LEFT
        --output $OUTPUT_RIGHT --auto --right-of $OUTPUT_CENTRE
        "
        PANEL_ON="monitor-1"
        ;;
    *)
        echo "$USAGE"
        exit 1
esac

XFCE_PANEL_OUTPUT="--verbose --channel xfce4-panel --property /panels/panel-0/output-name"

set -x

xrandr $XRANDR && xfconf-query $XFCE_PANEL_OUTPUT --set "$PANEL_ON"
