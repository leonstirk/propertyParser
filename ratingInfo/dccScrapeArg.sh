#!/bin/bash


# A=348577 # Emerson Street
# A=331940 # Marion Street
# A=309236 # Lots of titles
# A=309144 # No record

A=$1

while [ $A -lt $(($1+1)) ]; do
    ID=$( printf '%06d' $A )

    echo $ID;
    
    W=$(curl -s http://www.dunedin.govt.nz/services/rates-information/rates?ratingID=$ID | pup | sed -n '/PAGE CONTENT GOES HERE -->/,/content -->/p' | sed 's/://g' | sed 's/<br>/:/g')

    # curl -s http://www.dunedin.govt.nz/services/rates-information/rates?ratingID=$ID | pup | sed -n '/PAGE CONTENT GOES HERE -->/,/content -->/p' | sed 's/://g' | sed 's/<br>/:/g' | pup > page.html

    # W=$(cat page.html)

    NODETAILS=$(echo $W | sed -n '/There are no current Ratepayer details/p');

    OUTHED=()
    OUTPUT=()

    if [ -z "$NODETAILS" ]
    then
	echo "Record exists";

	# Get all the tables in page P
	P=$(echo $W | pup 'table.dTable json{}')
	# Find how many tables in page P
	TLN=$(echo $P | jq 'length')

	# i operates on each table
	i=0
	while [ $i -lt $TLN ]; do
	    # Get table i and find how many sections in table i (caption, thead, tbody, tfoot etc)
	    T=$(echo $P | jq '.['$i']')
	    SLN=$(echo $T | jq '[.children[]] | length')

	    # j operates on each section (caption, thead, tbody, tfoot, etc)
	    j=0
	    while [ $j -lt $SLN ]; do
		S=$(echo $T | jq '[.children['$j']]')

		# Identify section type
		ISCAP=$(echo $S | jq 'map(select(.tag == "caption")) | length > 0')
		ISHED=$(echo $S | jq 'map(select(.tag == "thead")) | length > 0')
		ISBOD=$(echo $S | jq 'map(select(.tag == "tbody")) | length > 0')

		# If caption, camel case it and store in variable CAP to prepend to column names
		if [ $ISCAP == 'true' ]; then
		    CAP=$(echo $S | jq '.[].text' | sed 's/"//g' | awk '{ for ( i=1; i <= NF; i++) { sub(".", substr(toupper($i), 1,1) , $i); print $i; } }' | awk 'BEGIN{RS=" "}''{print $1$2}');
		fi

		# If thead, camel case each header and store in array HED to prepend to column names
		if [ $ISHED == 'true' ];then
		    HED=$(echo $S | jq '.[].children[].children[].text' | sed 's/^"//g' | sed 's/"$/,/g' | awk '{ for ( i=1; i <= NF; i++) { sub(".", substr(toupper($i), 1,1) , $i); print $i; } }')
		    HED=$(echo $HED | sed 's/ //g')
		    IFS=',' read -r -a HED <<< "$HED"
		fi

		# If tbody, separate out the th from the td.
		# Camel case the th values and then store in HBOD and DBOD variables.
		# CAP and HED will prepend HBOD.

		if [ $ISBOD == 'true' ]; then

		    # Define HBOD and DBOD arrays
		    HBOD=()
		    DBOD=()

		    # Find number of rows in the section
		    RLN=$(echo $S | jq '[.[].children[]] | length')

		    # k operates on each table row
		    k=0
		    while [ $k -lt $RLN ]; do
			R=$(echo $S | jq '[.[].children['$k']]')

			# Only process table rows with more than 1 cell
			CLN=$(echo $R | jq '[.[].children[]] | length')
			if [ $CLN -gt 1 ]; then

			    # l operates on each table cell
			    l=0
			    while [ $l -lt $CLN ]; do
				C=$(echo $R | jq '[.[].children['$l']]')

				# Identify cell type
				ISTH=$(echo $C | jq 'map(select(.tag == "th")) | length > 0')
				ISTD=$(echo $C | jq 'map(select(.tag == "td")) | length > 0')

				# If table header cell, store in an array
				if [ $ISTH == 'true' ]; then
				    DATA=$(echo $C | jq '.[].text' | sed 's/^"//g' | sed 's/"$//g' | awk '{ for ( i=1; i <= NF; i++) { sub(".", substr(toupper($i), 1,1) , $i); print $i; } }')
				    DATA=$(echo $DATA | sed 's/ //g')
				    HBOD=("${HBOD[@]}" "$DATA")
				fi

				if [ $ISTD == 'true' ]; then
				    DATA=$(echo $C | jq '.[].text' | sed 's/, /;/g' | sed 's/,//g' | sed 's/^"//g' | sed 's/"$/,/g' | sed 's/null/null,/g')
				    DBOD=("${DBOD[@]}" "$DATA")
				fi

				l=$(($l+1))

			    done
			fi

			DBOD=("${DBOD[@]};")
			k=$(($k+1))

		    done

		fi

		j=$(($j+1))

	    done
	    
	    if [ ${#HED[@]} -gt 0 ]; then
		# Need to define HBOD for tables with a header row (HED)

		TMP=()
		HBOD=()

		DBOD=$(echo ${DBOD[@]} | sed 's/,;/;/g' )

		IFS=';' read -r -a TMP <<< "$DBOD"
		DBOD=()

		n=0
		while [ $n -lt ${#TMP[@]} ]; do
		    IFS=',' read -r -a CELS <<< "${TMP[$n]}"

		    m=1
		    while [ $m -lt ${#CELS[@]} ]; do

			CC=$(echo ${CELS[0]} |  awk '{ for ( i=1; i <= NF; i++) { sub(".", substr(toupper($i), 1,1) , $i); print $i; } }')
			CC=$(echo $CC | sed 's/ //g')
			HBOD=("${HBOD[@]}" "$CAP.$CC.${HED[$m]}")
			DBOD=("${DBOD[@]}" "${CELS[$m]}")

			m=$(($m+1))
		    done

		    n=$(($n+1))
		done

		# echo $(IFS=, ; echo "${HBOD[*]}") >> test.csv
		# echo $(IFS=, ; echo "${DBOD[*]}") >> test.csv

	    else


		TMP=()
		for n in ${HBOD[@]}; do
		    TMP=("${TMP[@]}" "$CAP.$n")
		done
		HBOD=("${TMP[@]}")
		TMP=()
		DBOD=$(echo ${DBOD[@]} | sed 's/; //g' | sed 's/,;//g')
		IFS=',' read -r -a DBOD <<< "$DBOD"

		# echo $(IFS=, ; echo "${HBOD[*]}") >> test.csv
		# echo $(IFS=, ; echo "${DBOD[*]}") >> test.csv

	    fi

	    OUTHED=("${OUTHED[@]}" "${HBOD[@]}")
	    OUTPUT=("${OUTPUT[@]}" "${DBOD[@]}")

	    TMP=()
	    CAP=()
	    HED=()
	    HBOD=()
	    DBOD=()

	    i=$(($i+1))
	done

	OUTHED=("ID" "${OUTHED[@]}")
	OUTPUT=("$ID" "${OUTPUT[@]}")

	echo $(IFS=, ; echo "${OUTHED[*]}") >> csv/$ID.csv
	echo $(IFS=, ; echo "${OUTPUT[*]}") >> csv/$ID.csv
	
	echo "OK";
    fi

    if [ -n "$NODETAILS" ]
    then
	echo "No record exists"
    fi

    #call time randomizer

    FLATTIME=$(date "+%H%M");
    RANGE=0
    MINIMUM=0

    RAND=$(( $RANGE * $RANDOM / 32767 + $MINIMUM))

    echo "wait $RAND";
    sleep $RAND;

    let A=A+1
done
