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



phantomjs --ssl-protocol=any companyDetail.js 6529532

# cat company.html | pup '.companySummary, .otherDetailsTable, #directorsPanel, #shareholdersPanel, #addressPanel, #documentsListPanel json{}' | jq '.' > company.json

cat company.html | pup '.companySummary' | pup '.row json{}' > company.json

cat company.json | jq 'recurse(.[]) | .text' > company.dat
