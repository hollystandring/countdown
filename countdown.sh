#!/bin/sh

# A countdown timer
# GNU GPLv3

for f in /tmp/countdown.*; do
    if [ -e "$f" ]; then
        printf "There may be another instance of this script running. If you are sure there is not, delete the file /tmp/countdown.XXXXX and try again.\n"
    else
        # Make a temporary file that will store the current time remaining
        TMP=$(mktemp /tmp/countdown.XXXXX)
        trap 'rm -rf "$TMP"; trap - EXIT; exit' EXIT INT HUP

        # If there are 3 arguments given, they become H, M, and S. Otherwise, the user is asked
        if [ $# -eq 3 ]; then
            HOU=$1
            MIN=$2
            SEC=$3
        else
            read -r -p 'Hours: ' HOU
            read -r -p 'Minutes: ' MIN
            read -r -p 'Seconds: ' SEC

        fi

        # Convert input to seconds
        TIMER=$(( (HOU*3600) + (MIN*60) + SEC ))

        # Count down and output remaining time to temp file
        while [ $TIMER -gt 0 ]
        do
            printf "%02dh:%02dm:%02ds\n" $((TIMER/3600)) $((TIMER%3600/60)) $((TIMER%60))
            printf "%02d:%02d:%02d\n" $((TIMER/3600)) $((TIMER%3600/60)) $((TIMER%60)) >> "$TMP"
            sleep 1
            TIMER=$(( TIMER - 1 ))
        done

        # Notify the user and play a sound when the timer reaches 0
        notify-send "Timer Finished!"
        mpv ~/scripts/alarm.ogg
    fi
done
