#!/bin/sh

# A countdown timer

if [ -e /tmp/countdown* ]; then
    echo "There may be another instance of this script running. If you are sure there is not, delete the file /tmp/countdown.XXXXX and try again."
else
    # Make a temporary file that will store the current time remaining
    TMP=$(mktemp /tmp/countdown.XXXXX)
    trap "rm -r $TMP" EXIT

    # Converts seconds to the format H:M:S
    function sec_to_hms () {
        N=$1
        M=0
        H=0
        if (($N>59)); then
            ((S=$N%60))
            ((N=$N/60))
            if (($N>59)); then
                ((M=$N%60))
                ((N=$N/60))
                ((H=$N))
            else
                ((M=$N))
            fi
        else
            ((S=$N))
        fi
        echo "$H":"$M":"$S"
    }

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
        echo $(sec_to_hms $TIMER)
        echo $(sec_to_hms $TIMER) >> $TMP
        sleep 1
        TIMER=$(( $TIMER - 1 ))
    done

    # Notify the user and play a sound when the timer reaches 0
    notify-send "Timer Finished!"
    mpv ~/scripts/alarm.ogg
fi
