#!/bin/bash

rm -f qldcScrape.json

A=$1

while [  $A -lt $(($1+1)) ]; do
    ID=$( printf '%05d' $A )

    echo $ID;

    W=$(curl -s "https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo="$ID | pup 'div.cssContentWorkspace' )
    
    # curl -s "https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo="$ID | pup 'div.cssContentWorkspace' > page.html

    # W=$(cat page.html)

    # Check the arrays are of the same length

    HLEN=$(echo $W | pup '.pageComponentHeading json{}' | jq 'map(select(.)) | length')
    BLEN=$(echo $W | pup 'table tbody json{}' | jq 'map(select(.)) | length')

    if [ $HLEN -eq $BLEN ]; then

	DOCUMENT='{ "PropertyNumber": "'$ID'",'

        B=$(echo $W | pup 'table tbody json{}' | jq '.')

        # i loops through each table section

	B1=$(echo $B | jq '.[0].children[0].children[0].text' | sed 's/"//g' | sed 's/ //g')
	B2=$(echo $B | jq '.[1].children[0].children[0].text' | sed 's/"//g' | sed 's/ //g')
	B3=$(echo $B | jq '.[2].children[0].children[0].text' | sed 's/"//g' | sed 's/ //g')

	# echo $B1
	# echo $B2
	# echo $B3
	# echo $B4

	# break

        i=0
        while [ $i -lt $HLEN ]; do

            T=$(echo $B | jq '[.['$i']]')
	    HCOL=$(echo $B | jq '.['$i'].children[0].children[0].class')
	    HROW=$(echo $B | jq '.['$i'].children[0].class')
	    HROWLEN=$(echo $B | jq '[.['$i'].children[0].children[]] | length')

	    # Decide if table has header cols or a header row

	    if [ $HCOL == '"headerColumn"' ]; then
		something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ /_/g' | sed 's/://g')
		arr=($something)
		j=0
		THING=""
		while [ $j -lt ${#arr[@]} ]; do
		    if [ $(($j % 2)) -eq 0 ]; then
			J=${arr[$j]}
			THING=$THING$J": "
		    fi
		    if [ $(($j % 2)) -eq 1 ]; then
			K=${arr[$j]}
			THING=$THING$K
			if [ $j -lt $((${#arr[@]}-1)) ]; then
			    THING=$THING','
			fi
		    fi
		    let j=$j+1
		done

		DOCUMENT=$DOCUMENT$THING
	    fi

	    if [ $HROW == '"headerRow"' ]; then

		if [ $HROWLEN == 2 ]; then

		    if [ $B1 != $B2 ]; then

			if [ $i -eq 1 ]; then
			    LEN=$(echo $T | jq '[.[].children[].children[]] | length')
			    something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ /_/g' | sed 's/://g')
			    arr=($something)
			    THING='"Owners": ['
			    j=2
			    while [ $j -lt $LEN ]; do

				if [ $(($j % 2)) -eq 0 ]; then
				    THING=$THING'{"Owner'$(($j/2))'": '${arr[$j]}','
				fi
				if [ $(($j % 2)) -eq 1 ]; then
				    THING=$THING'"PostalAddress'$(($j/2))'": '${arr[$j]}'}'
				    if [ $j -lt $(($LEN-2)) ]; then
					THING=$THING','
				    fi
				fi

				let j=$j+1
			    done
			    THING=$THING']'

			    DOCUMENT=$DOCUMENT','$THING
			fi

			if [ $i -gt 1 ]; then
			    LEN=$(echo $T | jq '[.[].children[].children[]] | length')
			    something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ /_/g' | sed 's/://g' | sed 's/*//g')
			    arr=($something)
			    THING=''
			    j=2

			    while [ $j -lt $LEN ]; do
				if [ $(($j % 2)) -eq 0 ]; then
				    J=${arr[$j]}
				    THING=$THING$J": "
				fi
				if [ $(($j % 2)) -eq 1 ]; then
				    K=${arr[$j]}
				    THING=$THING$K
				    if [ $j -lt $(($LEN-1)) ]; then
					THING=$THING','
				    fi
				fi
				let j=$j+1
			    done

			    DOCUMENT=$DOCUMENT','$THING
			fi

		    fi

		    if [ $B1 == $B2 ]; then

		    	if [ $i -eq 2 ]; then
		    	    LEN=$(echo $T | jq '[.[].children[].children[]] | length')
		    	    something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ /_/g' | sed 's/://g')
		    	    arr=($something)
		    	    THING='"Owners": ['
		    	    j=2
		    	    while [ $j -lt $LEN ]; do

		    		if [ $(($j % 2)) -eq 0 ]; then
		    		    THING=$THING'{"Owner'$(($j/2))'": '${arr[$j]}','
		    		fi
		    		if [ $(($j % 2)) -eq 1 ]; then
		    		    THING=$THING'"PostalAddress'$(($j/2))'": '${arr[$j]}'}'
		    		    if [ $j -lt $(($LEN-2)) ]; then
		    			THING=$THING','
		    		    fi
		    		fi

		    		let j=$j+1
		    	    done
		    	    THING=$THING']'

		    	    DOCUMENT=$DOCUMENT','$THING
		    	fi

		    	if [ $i -gt 2 ]; then
		    	    LEN=$(echo $T | jq '[.[].children[].children[]] | length')
		    	    something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ /_/g' | sed 's/://g' | sed 's/*//g')
		    	    arr=($something)
		    	    THING=''
		    	    j=2

		    	    while [ $j -lt $LEN ]; do
		    		if [ $(($j % 2)) -eq 0 ]; then
		    		    J=${arr[$j]}
		    		    THING=$THING$J": "
		    		fi
		    		if [ $(($j % 2)) -eq 1 ]; then
		    		    K=${arr[$j]}
		    		    THING=$THING$K
		    		    if [ $j -lt $(($LEN-1)) ]; then
		    			THING=$THING','
		    		    fi
		    		fi
		    		let j=$j+1
		    	    done

		    	    DOCUMENT=$DOCUMENT','$THING
		    	fi

		    fi

		    if [ $B2 == $B3 ]; then

		    	if [ $i -eq 3 ]; then
		    	    LEN=$(echo $T | jq '[.[].children[].children[]] | length')
		    	    something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ /_/g' | sed 's/://g')
		    	    arr=($something)
		    	    THING='"Owners": ['
		    	    j=2
		    	    while [ $j -lt $LEN ]; do

		    		if [ $(($j % 2)) -eq 0 ]; then
		    		    THING=$THING'{"Owner'$(($j/2))'": '${arr[$j]}','
		    		fi
		    		if [ $(($j % 2)) -eq 1 ]; then
		    		    THING=$THING'"PostalAddress'$(($j/2))'": '${arr[$j]}'}'
		    		    if [ $j -lt $(($LEN-2)) ]; then
		    			THING=$THING','
		    		    fi
		    		fi

		    		let j=$j+1
		    	    done
		    	    THING=$THING']'

		    	    DOCUMENT=$DOCUMENT','$THING
		    	fi

		    	if [ $i -gt 3 ]; then
		    	    LEN=$(echo $T | jq '[.[].children[].children[]] | length')
		    	    something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ /_/g' | sed 's/://g' | sed 's/*//g')
		    	    arr=($something)
		    	    THING=''
		    	    j=2

		    	    while [ $j -lt $LEN ]; do
		    		if [ $(($j % 2)) -eq 0 ]; then
		    		    J=${arr[$j]}
		    		    THING=$THING$J": "
		    		fi
		    		if [ $(($j % 2)) -eq 1 ]; then
		    		    K=${arr[$j]}
		    		    THING=$THING$K
		    		    if [ $j -lt $(($LEN-1)) ]; then
		    			THING=$THING','
		    		    fi
		    		fi
		    		let j=$j+1
		    	    done

		    	    DOCUMENT=$DOCUMENT','$THING
		    	fi

		    fi


		fi

		if [ $HROWLEN == 5 ]; then
		    LEN=$(echo $T | jq '[.[].children[].children[]] | length')
		    something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ /_/g' | sed 's/://g')
		    arr=($something)
		    THING='"Rates": ['
		    j=5
		    while [ $j -lt $((${#arr[@]}-3)) ]; do
			k=$(($j % 5))

			case $k in
			    0)
				THING=$THING'{"Reference": '${arr[$j]}','
				;;
			    1)
				THING=$THING'"Description": '${arr[$j]}','
				;;
			    2)
				THING=$THING'"Factor": '${arr[$j]}','
				;;
			    3)
				THING=$THING'"Rate": '${arr[$j]}','
				;;
			    4)
				THING=$THING'"Amount": '${arr[$j]}'}'
				if [ $j -lt $((${#arr[@]}-4)) ]; then 
				    THING=$THING','
				fi
				;;  
			esac

			let j=$j+1
		    done
		    THING=$THING']'

		    DOCUMENT=$DOCUMENT','$THING
		fi

	    fi

	    let i=$i+1
	done

	DOCUMENT=$DOCUMENT'},'
	echo $DOCUMENT >> qldcScrape.dat

    fi

    let A=$A+1
done

# cat qldcScrape.dat | sed '$ s/.$//' | sed '1s/^/[/' | sed -e "\$a]" | sed 's/""/","/g' | jq '.' > qldcScrape.json
