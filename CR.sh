#!/bin/bash

DATE=`date --date='$1' +%d%b%Y`

phantomjs --ssl-protocol=any CR.js

cat companies.html | pup '.dataList table tbody tr json{}' | jq '.' > companies.json

JSON=$(cat companies.json)

C=$(echo $JSON | jq '[.[]]')
CLEN=$(echo $C | jq '. | length')

rm -f tmp.json
i=0

while [ $i -lt $CLEN ]; do

    echo $C | jq '.['$i'] | recurse(.children[]) | .text' | sed '/null/d' | sed 's/"//g' > tmp.dat

    L=$(cat tmp.dat | wc -l)

    if [ $L -gt 3 ]; then
	j=0
	while IFS='' read -r line || [[ -n "$line" ]]; do
	    case $j in
		0)
		    J="{'companyName': '$line',"
		    ;;
		1)
		    edit=$(echo $line | sed 's/(//g' | sed 's/)//g' | sed 's/NZBN: //g')
		    arr=($edit)
		    J="$J 'companyNumber': '${arr[0]}', 'NZBN': '${arr[1]}', 'companyStatus': '${arr[2]}',"
		    ;;
		2)
		    J="$J 'entityType': '$line',"
		    ;;
		3)
		    J="$J 'registeredOffice': '$line',"
		    ;;
		4)
		    ;;
		5)
		    J="$J 'incorporationDate': '$line' }"
		    ;;
	    esac
	    let j=$j+1
	done < tmp.dat
	echo $J >> tmp.json
    fi

    let i=$i+1
done

cat tmp.json | sed 's/\x27/"/g' | jq '.' | sed 's/}/},/g' | sed '$ s/.$//' | sed '1s/^/[/' | sed -e "\$a]" > companies/$DATE.json
rm -f tmp.json
rm -f tmp.dat

rm -f companies.html
rm -f companies.json
# count total number ofobservations 
# cat companies/25Oct2017.json | jq '. | length'
