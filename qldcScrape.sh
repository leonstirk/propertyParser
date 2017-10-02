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
    PLEN=$(echo $W | pup 'table tbody json{}' | jq 'map(select(.)) | length')

    if [ $HLEN -eq $PLEN ]; then
	
	H=$(echo $W | pup '.pageComponentHeading json{}' | jq '.')
	P=$(echo $W | pup 'table tbody json{}' | jq '.')
	
	# i loops through each table section
	THED=()

	i=0
	while [ $i -lt $PLEN ]; do 

	    # create array of table headers
	    HED=$(echo $H | jq '.['$i'].text')
	    THED=("${THED[@]}" "$HED")

	    T=$(echo $P | jq '[.['$i']]')


	    COLHED=()
	    COLBOD=()
	    # count rows and loop through each row
	    RLN=$(echo $T | jq '[.[].children[]] | length')
	    j=0
	    while [ $j -lt $RLN ]; do

	    	R=$(echo $T | jq '[.[].children['$j']]')

		ISHED=$(echo $R | jq 'map(select(.class == "headerRow")) | length > 0')
		ISNRM=$(echo $R | jq 'map(select(.class == "normalRow")) | length > 0')
		ISALT=$(echo $R | jq 'map(select(.class == "alternateRow")) | length > 0')
		ISFOT=$(echo $R | jq 'map(select(.class == "footerRow")) | length > 0')

	    	CLN=$(echo $R | jq '[.[].children[]] | length')
	    	k=0
	    	while [ $k -lt $CLN ]; do
	    	    C=$(echo $R | jq '[.[].children['$k']]')

		    if [ $ISHED == 'true' ]; then
			NBTN=$(echo $C | jq '.[].text | length > 0')
			if [ $NBTN == 'true' ]; then
			    COLVAL=$(echo $C | jq '.[].text')
			else
			    COLVAL=$(echo $C | jq '.[].children[].text')
			fi

			COLHED=("${COLHED[@]}" "$COLVAL")
		    fi

		    if [ $ISNRM == 'true' -o $ISALT == 'true' -o $ISFOT == 'true' ]; then
			# If not a header row is it a header column?
			ISHC=$(echo $C | jq '.[].class')
			if [ $ISHC == '"headerColumn"' ]; then 
			    COLVAL=$(echo $C | jq '.[].text')
			    COLHED=("{COLHED[@]}" "$COLVAL")
			else
		    	    COLVAL=$(echo $C | jq '.[].text')
			    COLBOD=("{COLBOD[@]}" "$COLVAL")
			fi

		    fi

	    	    let k=k+1
	    	done




	    	let j=j+1
	    done

	    if [ ${#COLHED[@]} -eq 0 ]; then
		CC=$(echo ${THED[$i]} |  awk '{ for ( i=1; i <= NF; i++) { sub(".", substr(toupper($i), 1,1) , $i); print $i; } }')
                CC=$(echo $CC | sed 's/ //g' | sed 's/"//g')
		echo $CC
	    else
		m=0
		while [ $m -lt ${#COLHED[@]} ]; do
		    CC=$(echo ${THED[$i]}'.'${COLHED[$m]} |  awk '{ for ( i=1; i <= NF; i++) { sub(".", substr(toupper($i), 1,1) , $i); print $i; } }')
                    CC=$(echo $CC | sed 's/ //g' | sed 's/"//g')
		    echo $CC
		    let m=m+1
		done
	    fi

	    let i=i+1
	done

    fi

    # echo $TEST

    let A=A+1
done
