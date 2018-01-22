#!/bin/bash

# fileAddress="companies/"$1
# json=$(cat $fileAddress | jq '.[].companyNumber')
# arr=($json)

# echo ${arr[3]}

# for i in "${arr[@]}"
# do
#     phantomjs --ssl-protocol=any companyDetail.js $i

#     cat company.html | pup '.dataList table tbody tr json{}' | jq '.' > companies.json
# done



# phantomjs --ssl-protocol=any companyDetail.js 6529532

# cat company.html | pup '.companySummary, .otherDetailsTable, #directorsPanel, #shareholdersPanel, #addressPanel, #documentsListPanel json{}' | jq '.' > company.json

# cat company.html | pup '.companySummary' | pup '.row json{}' > company.json


col2=$(cat company.html | pup '.companySummary .row json{}' | jq '[.[].text]')
col1=$(cat company.html | pup '.companySummary .row json{}' | jq '[.[].children[0].text]')
col3=$(cat company.html | pup '.companySummary .row json{}' | jq '[.[].children[1].children[0].text]')
col4=$(cat company.html | pup '.companySummary .row json{}' | jq '[.[].children[1].text]')

bkpIFS="$IFS"

IFS=',][' read -r -a array1 <<< $col1
IFS=',][' read -r -a array2 <<< $col2
IFS=',][' read -r -a array3 <<< $col3

array4=()
l=${#array1[@]}
i=1
while [ $i -lt $l ]; do
  array4[$i]=$(echo $col4 | jq '.['$i']' | sed 's/,/;/g')
  let i=$i+1
done

IFS="$bkpIFS"

l=${#array1[@]}
i=1
while [ $i -lt $l ]; do
    echo '{'${array1[$i]}${array3[$i]}': '${array2[$i]}${array4[$i]}'},'
let i=$i+1
done

echo ${#array1[@]}
echo ${#array2[@]}
echo ${#array3[@]}
echo ${#array4[@]}

echo ${array1[*]}



# cat company.json | jq 'recurse(.[]) | .text' > company.dat
