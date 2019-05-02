#!/bin/sh

# A countdown timer

if [ -e /tmp/countdown* ]; then
    printf "There may be another instance of this script running. If you are sure there is not, delete the file /tmp/countdown.XXXXX and try again.\n"
else
    # Make a temporary file that will store the current time remaining
    TMP=$(mktemp /tmp/countdown.XXXXX)
    trap "rm -r $TMP" EXIT

    # If there are 3 arguments given, they become H, M, and S. Otherwise, the user is asked
    if (($# == 3)); then
        HOURS=$1
        MINUTES=$2
        SECONDS=$3
    else
        read -p 'Hours: ' HOURS
        read -p 'Minutes: ' MINUTES
        read -p 'Seconds: ' SECONDS
    fi

    # Convert input to seconds
    TIMER=$(( ($HOURS*3600) + ($MINUTES*60) + $SECONDS ))

    # Count down and output remaining time to temp file
    while [[ $TIMER -gt 0 ]]
    do
        printf "%02dh:%02dm:%02ds\n" $(($TIMER/3600)) $(($TIMER%3600/60)) $(($TIMER%60))
        printf "%02d:%02d:%02d\n" $(($TIMER/3600)) $(($TIMER%3600/60)) $(($TIMER%60)) >> $TMP
        sleep 1
        TIMER=$(( $TIMER - 1 ))
    done

    # Notify the user and play a sound when the timer reaches 0
    notify-send "Timer Finished!"
    mpv ~/scripts/alarm.ogg
fi
