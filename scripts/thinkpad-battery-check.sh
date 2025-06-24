#!/bin/bash

# Open the crontab file for editing:
#
# $ crontab -e
#
# Add a line to run the script every few minutes, for example, every 5 minutes:
#
# */5 * * * * <PATH TO>/battery_check.sh
#
# Make sure `notify-send` works, test with:
#
# $ notify-send "test"

# File to store flags
FLAG_FILE="$HOME/.battery_notify_flags"

# Thresholds
LOW_T=30
NORM_T=20
CRIT_T=10

# Initialize or read flags from the file
if [[ -f $FLAG_FILE ]]; then
  source $FLAG_FILE
else
  touch $FLAG_FILE
  echo "notified_low=\"false\"" >$FLAG_FILE
  echo "notified_norm=\"false\"" >>$FLAG_FILE
  echo "notified_charged=\"false\"" >>$FLAG_FILE
  source $FLAG_FILE
fi

# Battery paths
BAT_1=/sys/class/power_supply/BAT0/
BAT_2=/sys/class/power_supply/BAT1/

# Read battery information
B1_STATUS=$(cat $BAT_1/status)
B2_STATUS=$(cat $BAT_2/status)
B1_CAP=$(cat $BAT_1/capacity)
B2_CAP=$(cat $BAT_2/capacity)

echo "Battery 1: $B1_CAP% $B1_STATUS"
echo "Battery 2: $B2_CAP% $B2_STATUS"

# Calculate average capacity
CAP=$(((B1_CAP + B2_CAP) / 2))

# Determine overall battery status
STATUS=""
if [ "$B1_STATUS" = "Discharging" ] || [ "$B2_STATUS" = "Discharging" ]; then
  STATUS="Discharging"
  notified_charged="false"
elif [ "$B1_STATUS" = "Charging" ] || [ "$B2_STATUS" = "Charging" ]; then
  STATUS="Charging"
  notified_low="false"
  notified_norm="false"
else
  STATUS="Unknown"
fi


# Send notifications based on battery level and status
if [ "$STATUS" = "Discharging" ]; then
  if [ "$CAP" -le "$CRIT_T" ]; then
    notify-send -u critical "Battery Critically Low! $CAP%"
  elif [ "$CAP" -le "$NORM_T" ] && [ "$notified_norm" != "true" ]; then
    notify-send -u normal "Battery Low! $CAP%"
    notified_norm="true"
  elif [ "$CAP" -le "$LOW_T" ] && [ "$notified_low" != "true" ]; then
    notify-send -u low "Battery Low $CAP%"
    notified_low="true"
  fi
fi

if [ "$STATUS" = "Charging" ] && [ "$CAP" -ge 80 ]; then
  
  if [ "$notified_charged" != "true" ]; then
    notify-send -u normal "Battery Charged to $CAP%"
    notified_charged="true"
  fi
fi

echo "notified_low=\"$notified_low\"" >$FLAG_FILE
echo "notified_norm=\"$notified_norm\"" >>$FLAG_FILE
echo "notified_charged=\"$notified_charged\"" >>$FLAG_FILE