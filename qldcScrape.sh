#!/bin/bash

A=28086

while [  $A -lt 28087 ]; do
    ID=$( printf '%05d' $A )

    echo $ID;

    # W=$(curl -s https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo=$ID | pup | sed -n '/class="pageComponentHeading">Property Details/,/ctl00_Content_ctrlMap_hidWmsBoundaries/p')

    # curl -s "https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo="$ID | pup 'div.cssContentWorkspace' > page.html

    W=$(cat page.html)

    # Split into an array of titles and an array of tables
    H=$(echo $W | pup '.pageComponentHeading json{}')
    T=$(echo $W | pup 'table tbody json{}')

    # Check the arrays are of the same length
    HLEN=$(echo $H | jq 'map(select(.)) | length')
    TLEN=$(echo $T | jq 'map(select(.)) | length')

    echo $HLEN
    echo $TLEN

    if [ $HLEN -eq $TLEN ]; then
	echo 'Lengths are equal. Proceed'
	
	# i loops through each table
	i=0
	while [ $i -lt $HLEN ]; do 
	    B=$(echo $H | jq '.['$i'].text')

	    RLEN=$(echo $T | jq '[.['$i'].children[]] | length')
	    echo $RLEN

	    j=0
	    while [ $j -lt $RLEN ]; do
		CLEN=$(echo $T | jq '[.['$i'].children['$j'].children[]] | length')

		k=0
		while [ $k -lt $CLEN ]; do
		    echo $T | jq '.['$i'].children['$j'].children['$k'].text'
		    let k=k+1
		done

		let j=j+1
	    done


	    let i=i+1

	done


    fi

    # echo $TEST

    let A=A+1
done
