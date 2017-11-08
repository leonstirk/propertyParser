#!/bin/bash

A=28086

while [  $A -lt 28087 ]; do
    ID=$( printf '%05d' $A )

    echo $ID;

    # W=$(curl -s https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo=$ID | pup | sed -n '/class="pageComponentHeading">Property Details/,/ctl00_Content_ctrlMap_hidWmsBoundaries/p')

    # curl -s "https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo="$ID | pup 'div.cssContentWorkspace' > page.html

    W=$(cat page.html)

    # Check the arrays are of the same length

    HLEN=$(echo $W | pup '.pageComponentHeading json{}' | jq 'map(select(.)) | length')
    BLEN=$(echo $W | pup 'table tbody json{}' | jq 'map(select(.)) | length')

    if [ $HLEN -eq $BLEN ]; then

        H=$(echo $W | pup '.pageComponentHeading json{}' | jq '.')
        B=$(echo $W | pup 'table tbody json{}' | jq '.')

        # i loops through each table section
        TABLES=()

        i=0
        while [ $i -lt $HLEN ]; do

            # create array of table headers
            TH=$(echo $H | jq '.['$i'].text')
            THS=("${THS[@]}" "$TH")

            T=$(echo $B | jq '[.['$i']]')
	    HCOL=$(echo $B | jq '.['$i'].children[0].children[0].class')
	    HROW=$(echo $B | jq '.['$i'].children[0].class')
	    HROWLEN=$(echo $B | jq '[.['$i'].children[0].children[]] | length')

	    # Decide if table has header cols or a header row

	    if [ $HCOL == '"headerColumn"' ]; then
		something=$(echo $T | jq '.[].children[].children[].text' | sed 's/ //g' | sed 's/://g')
		arr=($something)
		echo ${arr[@]}
		j=0
		THING="{"
		while [ $j -lt ${#arr[@]} ]; do
		    if [ $(($j % 2)) -eq 0 ]; then
			J=${arr[$j]}
			THING=$THING$J": "
		    fi
		    if [ $(($j % 2)) -eq 1 ]; then
			K=${arr[$j]}
			THING=$THING$K","
		    fi
		    let j=$j+1
		done
		THING=$THING"}"
		echo $THING
	    fi

	    # if [ $HROW == '"headerRow"' ]; then

	    # 	if [ $HROWLEN == 2 ]; then
	    # 	    # "Table.RowHeader":"Value"
	    # 	    echo $T | jq '.[].children[].children[].text'
	    # 	fi

	    # 	if [ $HROWLEN == 5 ]; then
	    # 	    # "Table.RowHeader.Description":"Value"
	    # 	    echo $T | jq '.[].children[].children[].text'
	    # 	fi

	    # fi


	    # Array of keys
	    # Array of values

	    let i=$i+1
	done
    fi

    let A=$A+1

    echo ${THS[@]}
    echo $B | jq '[.[3].children[0].children[]] | length'

done
