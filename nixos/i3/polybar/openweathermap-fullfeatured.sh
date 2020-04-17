#!/usr/bin/env bash

source $HOME/.open-secrets.sh

KEY="$OPENWEATHERMAP_KEY"
CITY=""
UNITS="metric"
SYMBOL="°"

API="https://api.openweathermap.org/data/2.5"

CURL=`which curl`
CURL="$CURL -sf"
CUT=`which cut`
DATE=`which date`
JQ=`which jq`
UNAME=`which uname`

get_icon() {
    case $1 in
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
    esac

    echo $icon
}

get_duration() {

    osname=$($UNAME -s)

    case $osname in
        *BSD) $DATE -r "$1" -u +%H:%M;;
        *) $DATE --date="@$1" -u +%H:%M;;
    esac

}

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    current=$($CURL "$API/weather?appid=$KEY&$CITY_PARAM&units=$UNITS")
    forecast=$($CURL "$API/forecast?appid=$KEY&$CITY_PARAM&units=$UNITS&cnt=1")
else
    location=$($CURL https://location.services.mozilla.com/v1/geolocate?key=geoclue)

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | $JQ '.location.lat')"
        location_lon="$(echo "$location" | $JQ '.location.lng')"

        current=$($CURL "$API/weather?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
        forecast=$($CURL "$API/forecast?appid=$KEY&lat=$location_lat&lon=$location_lon&units=$UNITS&cnt=1")
    fi
fi

if [ -n "$current" ] && [ -n "$forecast" ]; then
    current_temp=$(echo "$current" | $JQ ".main.temp" | $CUT -d "." -f 1)
    current_icon=$(echo "$current" | $JQ -r ".weather[0].icon")

    forecast_temp=$(echo "$forecast" | $JQ ".list[].main.temp" | $CUT -d "." -f 1)
    forecast_icon=$(echo "$forecast" | $JQ -r ".list[].weather[0].icon")


    if [ "$current_temp" -gt "$forecast_temp" ]; then
        trend=""
    elif [ "$forecast_temp" -gt "$current_temp" ]; then
        trend=""
    else
        trend=""
    fi

    echo "$(get_icon "$current_icon") $current_temp$SYMBOL  $trend  $(get_icon "$forecast_icon") $forecast_temp$SYMBOL"
fi
