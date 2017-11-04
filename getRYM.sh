#!/bin/bash

DATE=`date +%s`

phantomjs --ssl-protocol=any getRYM.js

cat RYM.html | pup '.instrument-snapshot, .instrument-info json{}' | jq '.' > RYM.json

JSON=$(cat RYM.json)

C=$(echo $JSON | jq '[.[]]')
CLEN=$(echo $C | jq '. | length')

rm -f tmp.json
i=0

J="{'accessTimestamp': '$DATE'," 
echo $J >> tmp.json

while [ $i -lt $CLEN ]; do

    echo $C | jq '.['$i'] | recurse(.children[]) | .text' | sed '/null/d' | sed 's/"//g' > tmp.dat

    case $i in 
    	0)
    	    j=0
    	    while IFS='' read -r line || [[ -n "$line" ]]; do
    		case $j in
    		    0)
			J="'tickerSymbol': '$line',"
    			;;
    		    1)
			J="$J 'spotPrice': '$line',"
    			;;
    		    2)
			edit=$(echo $line | sed 's/ \///g')
			arr=($edit)
			J="$J 'changeVal': '${arr[0]}', 'changePC': '${arr[1]}',"
    			;;
    		    3)
    			;;
    		    4)
			edit=$(echo $line | sed 's/ \///g')
			arr=($edit)
			J="$J 'change52WeekVal': '${arr[0]}', 'change52WeekPC': '${arr[1]}',"
    			;;
		    5)
			;;
		    6)
			J="$J 'instrumentName': '$line',"
			;;
		    7)
			;;
		    8)
			J="$J 'issuedBy': '$line',"
			;;
		    9)
			;;
		    10)
			J="$J 'ISIN': '$line',"
			;;
		    11)
			;;
		    12)
			J="$J 'type': '$line', "
			;;
    		esac
    		let j=$j+1
    	    done < tmp.dat
	    echo $J >> tmp.json
    	    ;;
    	1)
    	    j=0
    	    while IFS='' read -r line || [[ -n "$line" ]]; do
    		case $j in
    		    0)
    			;;
    		    1)
    			;;
    		    2)
			J="'tradingStatus': '$line',"
    			;;
    		    3)
			;;
		    4)
			J="$J 'tradesTodayTotal': '$line',"
			;;
		    5)
			;;
		    6)
			J="$J 'tradeValTotal': '$line',"
			;;
		    7)
			;;
		    8)
			J="$J 'tradeVolumeTotal': '$line',"
			;;
		    9)
			;;
		    10)
			J="$J 'capitalisation(000s)': '$line', "
			;;
		esac
    		let j=$j+1
    	    done < tmp.dat
	    echo $J >> tmp.json
    	    ;;
    	2)
    	    j=0
    	    while IFS='' read -r line || [[ -n "$line" ]]; do
    		case $j in
    		    0)
    			;;
    		    1)
    			;;
    		    2)
			J="'open': '$line',"
    			;;
    		    3)
			;;
		    4)
			J="$J 'high': '$line',"
			;;
		    5)
			;;
		    6)
			J="$J 'low': '$line',"
			;;
		    7)
			;;
		    8)
			J="$J 'highBid': '$line',"
			;;
		    9)
			;;
		    10)
			J="$J 'lowOffer': '$line', "
			;;
		esac
    		let j=$j+1
    	    done < tmp.dat
	    echo $J >> tmp.json
    	    ;;
    	3)
    	    j=0
    	    while IFS='' read -r line || [[ -n "$line" ]]; do
    		case $j in
    		    0)
    			;;
    		    1)
    			;;
    		    2)
			J="'P/E': '$line',"
    			;;
    		    3)
			;;
		    4)
			J="$J 'EPS': '$line',"
			;;
		    5)
			;;
		    6)
			J="$J 'NTA': '$line',"
			;;
		    7)
			;;
		    8)
			J="$J 'grossDivYield': '$line',"
			;;
		    9)
			;;
		    10)
			J="$J 'securitiesIssued': '$line' }"
			;;
		esac
    		let j=$j+1
    	    done < tmp.dat
	    echo $J >> tmp.json
    	    ;;
    esac

    let i=$i+1
done

cat tmp.json | sed 's/\x27/"/g' | jq '.' >> RYM.dat
rm -f tmp.json
rm -f tmp.dat
