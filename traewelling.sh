#!/bin/bash

# configure this to be your traewelling.de username
user=""

data=$(curl -s -X 'GET' \
  "https://traewelling.de/api/v1/user/$user/statuses" \
  -H 'accept: application/json' )


lineName=$(echo "$data" | jq -r '.data[0].train.lineName')
destination=$(echo "$data" | jq -r '.data[0].train.destination.name')
arrivalRealData=$(echo "$data" | jq -r '.data[0].train.destination.arrival')
dstPlatform=$(echo "$data" | jq -r '.data[0].train.destination.platform')
operator=$(echo "$data" | jq -r '.data[0].train.operator.name')

# calculate time remainint to arrival in hours and minutes
arrivalReal=$(date -d "$arrivalRealData" +%s)
now=$(date +%s)
timeRemaining=$((arrivalReal - now))

if [ $timeRemaining -lt 0 ]; then
  echo "Welcome to $destination"
  echo "$operator - Platform $dstPlatform"
  exit 0
fi

timeRemainingHours=$((timeRemaining / 3600))
timeRemainingMinutes=$(((timeRemaining - (timeRemainingHours*3600)) /60))
if [ "$timeRemainingHours" != "0" ]; then
  timeString="${timeRemainingHours}h${timeRemainingMinutes}m"
else
  timeString="${timeRemainingMinutes}m"
fi



echo "[$lineName] $destination - $timeString"
echo "$operator - Platform $dstPlatform"
