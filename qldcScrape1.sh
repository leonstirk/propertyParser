#!/bin/bash

A=28086

while [  $A -lt 28087 ]; do
    ID=$( printf '%05d' $A )

    echo $ID;

    # W=$(curl -s https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo=$ID | pup | sed -n '/class="pageComponentHeading">Property Details/,/ctl00_Content_ctrlMap_hidWmsBoundaries/p')

    # curl -s "https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo="$ID | pup 'div.cssContentWorkspace' > page.html

    W=$(cat page.html)



    # Check the arrays are of the same length

    A=$(echo $W | pup '.pageComponentHeading json{}' | jq 'map(select(.)) | length')
    B=$(echo $W | pup 'table tbody json{}' | jq 'map(select(.)) | length')

    if [ $A -eq $B ]; then

        H=$(echo $W | pup '.pageComponentHeading json{}' | jq '.')
        P=$(echo $W | pup 'table tbody json{}' | jq '.')

        # i loops through each table section
        TABLES=()

        i=0
        while [ $i -lt $A ]; do

            # create array of table headers
            TH=$(echo $H | jq '.['$i'].text')
            THS=("${THS[@]}" "$TH")

            T=$(echo $P | jq '[.['$i']]')



	    # Decide if table has header cols or a header row

	    if header columns
		# "Table.ColHeader":"Value"
	    fi

	    if header row
		if number of columns == 2
		    # "Table.RowHeader":"Value"
		fi

		if number of columns == 4
		    # "Table.RowHeader.Description":"Value"
		fi
	    fi

	    # Array of keys
	    # Array of values
