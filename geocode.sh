#!/bin/bash

touch dccGeoOut.csv

TOT=49565

while read i; do
    a=$(echo $i | sed 's/"//g')
    IFS=',' read -r -a b <<< "$a"
    p=$(echo ${b[2]} | sed 's/ /+/g')

    # c=$(curl -s https://maps.googleapis.com/maps/api/geocode/json?address=$p+Dunedin+New+Zealand&key=AIzaSyCSf-fiJxH5WlkAED4xaHyHlMrwXogGOD8)
    c=$(curl -s https://maps.googleapis.com/maps/api/geocode/json?address=$p+Dunedin+New+Zealand&key=AIzaSyDbmNiIUl1KT1tAWQB7wEbReoFv7nOhPck)

    formatted_address=$(echo $c | jq '.results[].formatted_address')
    arr=$(echo $c | jq '.results[].address_components[].long_name')
    lat=$(echo $c | jq '.results[].geometry.location.lat')
    lng=$(echo $c | jq '.results[].geometry.location.lng')
    echo $i, $formatted_address, $lat, $lng >> dccGeoOut.csv

    PC=$(bc <<< 'scale=4; ('${b[0]}'/'$TOT')*100')

    printf "\r${b[1]} : $PC%%"

done < ./xas
