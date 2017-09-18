#!/bin/bash

rm dccGeoOut.csv
touch dccGeoOut.csv

# while read i; do
#     a=$(echo $i | sed 's/"//g')
#     IFS=',' read -r -a b <<< "$a"
#     p=$(echo ${b[2]} | sed 's/ /+/g')

#     c=$(curl -s https://maps.googleapis.com/maps/api/geocode/json?address=$p+Dunedin+New+Zealand&key=AIzaSyCSf-fiJxH5WlkAED4xaHyHlMrwXogGOD8)

#     formatted_address=$(echo $c | jq '.results[].formatted_address')
#     arr=$(echo $c | jq '.results[].address_components[].long_name')
#     lat=$(echo $c | jq '.results[].geometry.location.lat')
#     lng=$(echo $c | jq '.results[].geometry.location.lng')
#     echo $i, $formatted_address, $lat, $lng >> dccGeoOut.csv
# done < ./geoSrc/dccGeoSrc.csv


c=$(curl -s https://maps.googleapis.com/maps/api/geocode/json?address=27+Emerson+Street+Concord+Dunedin+New+Zealand&key=AIzaSyCSf-fiJxH5WlkAED4xaHyHlMrwXogGOD8)

formatted_address=$(echo $c | jq '.results[].formatted_address')
arr=$(echo $c | jq '.results[].address_components[].long_name')
lat=$(echo $c | jq '.results[].geometry.location.lat')
lng=$(echo $c | jq '.results[].geometry.location.lng')
echo $i, $formatted_address, $lat, $lng >> dccGeoOut.csv
