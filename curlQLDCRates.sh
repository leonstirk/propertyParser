#!/bin/bash

A=28086
while [  $A -lt 28087 ]; do
# A=00001
# while [  $A -lt 00002 ]; do
    ID=$( printf '%05d' $A )

    echo $ID;

    WEBGET=$(curl -s "https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo="$ID | sed -n '/class="pageComponentHeading">Property Details/,/ctl00_Content_ctrlMap_hidWmsBoundaries/p' | sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' | sed 's/^[ \t]*//;s/[ \t]*$//');

    printf "$WEBGET" > output.txt;

    RECORDEXISTS=$(printf "$WEBGET" | sed -n '/<table classgrid cellspacing0 cellpadding3 rulescols border1 idctl00ContentcusRatingInformationrepPageComponentsctl00cusPageComponentGridrepWebGridctl00dtvWebGridListView stylewidth:100;bordercollapse:collapse;>/p');

    if [ -n "$RECORDEXISTS" ]
    then
	echo "Record exists";

	CLEANOP=$(printf "$WEBGET" | sed -e 's/<[^>]*>//g' | sed '/^$/d')

	VALUATIONNO=$(printf "$CLEANOP" | sed -n '/Valuation Number:/p' | sed 's/Valuation Number://g')
	PROPERTYADDRESS=$(printf "$CLEANOP" | sed -n '/Location:/p' | sed 's/Location://g')
	LEGALDECRIPTION=$(printf "$CLEANOP" | sed -n '/Legal Description:/p' | sed 's/Legal Description://g')
	CERTOFTITLE=$(printf "$CLEANOP" | sed -n '/Certificate Of Title/p' | sed 's/Certificate Of Title//g')
	NATUREIMPROVEMENTS=$(printf "$CLEANOP" | sed -n '/Nature Of Improvements:/p' | sed 's/Nature Of Improvements://g')
	VAC=$(printf "$CLEANOP" | sed -n '/Visitor Accommodation Code:/p' | sed 's/Visitor Accommodation Code://g')
	# OWNERS=$(printf "$CLEANOP" | sed -n '//p' | sed 's///g')
	# RATESADDRESS=$(printf "$CLEANOP" | sed -n '//p' | sed 's///g')
	# LANDVALUE=$(printf "$CLEANOP" | sed -n '//p' | sed 's///g')
	# CAPITALVALUE=$(printf "$CLEANOP" | sed -n '//p' | sed 's///g')
	# IMPROVEMENTVALUE=$(printf "$CLEANOP" | sed -n '//p' | sed 's///g')
	# LANDAREA=$(printf "$CLEANOP" | sed -n '//p' | sed 's///g')
	
	printf "$VALUATIONNO,$PROPERTYADDRESS,$LEGALDECRIPTION,$CERTOFTITLE,$NATUREIMPROVEMENTS,$VAC,$OWNERS,$RATESADDRESS,$LANDVALUE,$CAPITALVALUE,$IMPROVEMENTVALUE,$LANDAREA" >> ratingIDsQLDC.csv;
    fi

    if [ -z "$RECORDEXISTS" ]
    then
	echo "Record does not exist";
    fi
    
    # sleep 3;
    let A=A+1
done
