#!/bin/bash

NAMEDATE=`date +%d%b%Y`
ACCESSDATE=`date +%s`

phantomjs --ssl-protocol=any companiesScrape.js

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
		    J="$J 'accessTimestamp': '$ACCESSDATE',"
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

cat tmp.json | sed 's/\x27/"/g' | jq '.' | sed 's/}/},/g' | sed '$ s/.$//' | sed '1s/^/[/' | sed -e "\$a]" > $NAMEDATE.json

# insert into mongodb atlas

MONGOPASS="i08wh37Y"

atlasimport() {

db=$1
coll=$2
file_name=$3

mongoimport --host Cluster0-shard-0/cluster0-shard-00-00-gyynp.mongodb.net:27017,cluster0-shard-00-01-gyynp.mongodb.net:27017,cluster0-shard-00-02-gyynp.mongodb.net:27017 --ssl --username leonstirk --password $MONGOPASS --authenticationDatabase admin --db $db --collection $coll --type json --file $file_name --jsonArray
}

atlasimport test test $NAMEDATE.json

rm -f tmp.json
rm -f tmp.dat

rm -f companies.html
rm -f companies.json

rm -f $NAMEDATE.json

# count total number ofobservations 
# cat companies/25Oct2017.json | jq '. | length'
