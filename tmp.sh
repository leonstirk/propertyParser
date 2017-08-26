#!/bin/bash

rm -f json.json
touch json.json

A=331940
ID=$( printf '%06d' $A )

WEBGET=$(curl -s http://www.dunedin.govt.nz/services/rates-information/rates?ratingID=$ID | sed -n '/PAGE CONTENT GOES HERE -->/,/content -->/p')

TABLESLENGTH=$(echo $WEBGET | pup 'table json{}' | jq 'length')
TABLES=$(echo $WEBGET | pup 'table caption json{}')

TABLEROWSLENGTH=$(echo $WEBGET | pup 'table tbody .dTr json{}' | jq 'length')
TABLEROWS=$(echo $WEBGET | pup 'table tbody .dTr json{}')



i=0
# while [ $i -lt $TABLESLENGTH ]; do
while [ $i -lt 1 ]; do

    TABLE=$(echo $TABLES | jq '.['$i'] | .text')
    
    cat >> json.json <<EOF
{"tableName":$TABLE, "tableContents":[{
EOF
    
    j=0
    while [ $j -lt $TABLEROWSLENGTH ]; do

	KEY=$(echo $TABLEROWS | jq '.['$j'] | .children[].tag')
	VALUE=$(echo $TABLEROWS | jq '.['$j'] | .children[].text' | awk 'BEGIN{RS="\n"; ORS=":";}''{print}')
	
	
	if [ $j -gt 0 ]
	then
	    cat >> json.json <<EOF
,
EOF
	fi
	cat >> json.json <<EOF
{$VALUE}
EOF
	
    	j=$(($j+1))
    done

    cat >> json.json <<EOF
}]}
EOF
    
    i=$(($i+1))
done

