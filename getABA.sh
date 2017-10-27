#!/bin/bash

DATE=`date --date='yesterday' +%d%b%Y`

phantomjs --ssl-protocol=any getABA.js

cat ABA.html | pup '#snapshot, #activity, #performance, #fundamental json{}' | jq '.' > ABA.json

JSON=$(cat ABA.json)

C=$(echo $JSON | jq '[.[]]')
CLEN=$(echo $C | jq '. | length')

rm -f tmp.json
i=0

while [ $i -lt $CLEN ]; do

    echo $C | jq '.['$i'] | recurse(.children[]) | .text' | sed '/null/d' | sed 's/"//g' > tmp.dat

    L=$(cat tmp.dat | wc -l)

    S=$(cat tmp.dat)
    case $i in 
	0)
	    echo $S
	    j=0
	    while IFS='' read -r line || [[ -n "$line" ]]; do
		case $j in
		    0)
			;;
		    1)
			;;
		    2)
			;;
		    4)
			;;
		    5)
			;;
		esac
		let j=$j+1
	    done < tmp.dat
	    ;;
	1)
	    echo $S
	    ;;
	2)
	    echo $S
	    ;;
	3)
	    echo $S
	    ;;
    esac

    let i=$i+1
done


	# if [ $L -gt 3 ]; then

        #             0)
	# 		J="{'companyName': '$line',"
	# 		;;
        #             1)
	# 		edit=$(echo $line | sed 's/(//g' | sed 's/)//g' | sed 's/NZBN: //g')
	# 		arr=($edit)
	# 		J="$J 'companyNumber': '${arr[0]}', 'NZBN': '${arr[1]}', 'companyStatus': '${arr[2]}',"
	# 		;;
        #             2)
	# 		J="$J 'entityType': '$line',"
	# 		;;
        #             3)
	# 		J="$J 'registeredOffice': '$line',"
	# 		;;
	# 	esac
