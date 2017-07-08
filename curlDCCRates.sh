#!/bin/bash

A=309117
while [  $A -lt 331941 ]; do
# A=50
# while [  $A -lt 100 ]; do
  ID=$( printf '%06d' $A )

  echo $ID;
  
  WEBGET=$(curl -s http://www.dunedin.govt.nz/services/rates-information/rates?ratingID=$ID | sed -n '/dCaption">Property Details/,/ENDING RATE ACCOUNT MESSAGE/p' | sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' | sed 's/^[ \t]*//');

  NODETAILS=$(printf "$WEBGET" | sed -n '/There are no current Ratepayer details/p');
  
  if [ -z "$NODETAILS" ]
  then
      echo "Record exists";

      CLEANOP=$(printf "$WEBGET" | sed 's/<br \/>/; /g' | sed -e 's/<[^>]*>//g' | sed '/Top of this page/d;/Click the link below/d;/The Rates Breakdown provided/d;/The gross general rate column/d;/investments in Councilowned companies/d;/o give the net general rate/d;/function toggleBreak/d;/divT/d;/If you wish to object to your valuation/d' | sed '/^$/d')

      # Property Details

      PD=$(printf "$CLEANOP" | sed -n '/Property Details/,/Current Rates/p');

      VALUATIONNO=$(printf "$PD" | sed -n '/Valuation number/{n;p;}');
      RATEID=$(printf "$PD" | sed -n '/Rate account ID/{n;p;}')
      PROPERTYNO=$(printf "$PD" | sed -n '/Property number/{n;p;}')
      PROPERTYADDRESS=$(printf "$PD" | sed -n '/Property address/{n;p;}')
      CERTOFTITLE=$(printf "$PD" | sed -n '/Certificate(s) of title (guide only)/{n;p;}')
      RATEPAYERNAMES=$(printf "$PD" | sed -n '/Ratepayer name(s)/{n;p;}')
      POSTALADDRESS=$(printf "$PD" | sed -n '/Postal address for this assessment/,/Current Rates/p' | sed '/Postal address for this assessment/d;/Current Rates/d' | awk 'BEGIN{RS="\n"; ORS=" ";}''{print}')

      PDCSV="$VALUATIONNO, $RATEID, $PROPERTYNO, $PROPERTYADDRESS, $CERTOFTITLE, $RATEPAYERNAMES, $POSTALADDRESS"

      # Current Rates

      CR=$(printf "$CLEANOP" | sed -n '/Current Rates/,/Rates levied/p')

      CURRENTRATINGYEAR=$(printf "$CR" | sed -n '/Current rating year/{n;p;}')
      RATINGPERIOD=$(printf "$CR" | sed -n '/Rating period/{n;p;}')
      RATEABILITY=$(printf "$CR" | sed -n '/Rateability/{n;p;}' | sed 's/ //g')
      RATINGDIFFERENTIAL=$(printf "$CR" | sed -n '/Rating differential/{n;p;}')
      LANDUSE=$(printf "$CR" | sed -n '/Land use/{n;p;}')
      LEGALDESCRIPTION=$(printf "$CR" | sed -n '/Legal description/{n;p;}')
      AREA=$(printf "$CR" | sed -n '/Area in hectares/{n;p;}')
      VALUEOFIMPROVEMENTS=$(printf "$CR" | sed -n '/Value of improvements/{n;p;}' | sed 's/,//g')
      LANDVALUE=$(printf "$CR" | sed -n '/Land value/{n;p;}' | sed 's/,//g')
      CAPITALVALUE=$(printf "$CR" | sed -n '/Capital value/{n;p;}' | sed 's/,//g')
      SEPERATEPARTS=$(printf "$CR" | sed -n '/Separately used or inhabited parts/{n;p;}')

      CRCSV="$CURRENTRATINGYEAR, $RATINGPERIOD, $RATEABILITY, $RATINGDIFFERENTIAL, $LANDUSE, $LEGALDESCRIPTION, $AREA, $VALUEOFIMPROVEMENTS, $LANDVALUE, $SEPERATEPARTS"

      # Rates Levied

      RL=$(printf "$CLEANOP" | sed -n '/Rates levied/,/Show full rates breakdown/p')

      RCS=$(printf "$RL" | sed -n '/Residential Community Services/,/General Rate  Residential/p' | sed '$d' | sed '/Residential Community Services/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=",";}''{print}')
      GRR=$(printf "$RL" | sed -n '/General Rate  Residential/,/Residential Kerbside Recycling/p' | sed '$d' | sed '/General Rate  Residential/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=",";}''{print}')
      RKR=$(printf "$RL" | sed -n '/Residential Kerbside Recycling/,/Citywide Water Connected/p'  | sed '$d' | sed '/Residential Kerbside Recycling/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=",";}''{print}')
      CWC=$(printf "$RL" | sed -n '/Citywide Water Connected/,/Residential Drainage Connected/p'  | sed '$d' | sed '/Citywide Water Connected/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=",";}''{print}')
      RDC=$(printf "$RL" | sed -n '/Residential Drainage Connected/,/Show full rates breakdown/p' | sed '$d' | sed '/Residential Drainage Connected/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=",";}''{print}')

      RLCSV="$RCS$GRR$RKR$CWC$RDC"

      # Future Rates

      FR=$(printf "$CLEANOP" | sed -n '/Future Rates/,/Estimated Rates/p')

      FUTURERATINGYEAR=$(printf "$FR" | sed -n '/Future rating year/{n;p;}')
      FRATINGPERIOD=$(printf "$FR" | sed -n '/Future rating period/{n;p;}')
      FRATEABILITY=$(printf "$FR" | sed -n '/Rateability/{n;p;}' | sed 's/ //g')
      FRATINGDIFFERENTIAL=$(printf "$FR" | sed -n '/Rating differential/{n;p;}')
      FLANDUSE=$(printf "$FR" | sed -n '/Land use/{n;p;}')
      FLEGALDESCRIPTION=$(printf "$FR" | sed -n '/Legal description/{n;p;}')
      FAREA=$(printf "$FR" | sed -n '/Area in hectares/{n;p;}')
      FVALUEOFIMPROVEMENTS=$(printf "$FR" | sed -n '/Value of improvements/{n;p;}' | sed 's/,//g')
      FLANDVALUE=$(printf "$FR" | sed -n '/Land value/{n;p;}' | sed 's/,//g')
      FCAPITALVALUE=$(printf "$FR" | sed -n '/Capital value/{n;p;}' | sed 's/,//g')
      FSEPERATEPARTS=$(printf "$FR" | sed -n '/Separately used or inhabited parts/{n;p;}')

      FRCSV="$FUTURERATINGYEAR,$FRATINGPERIOD,$FRATEABILITY,$FRATINGDIFFERENTIAL,$FLANDUSE,$FLEGALDESCRIPTION,$FAREA,$FVALUEOFIMPROVEMENTS,$FLANDVALUE,$FCAPITALVALUE,$FSEPERATEPARTS"

      # Estimated Rates

      ER=$(printf "$CLEANOP" | sed -n '/Estimated Rates/,$p')

      EGRR=$(printf "$ER" | sed -n '/General Rate  Residential/,/Residential Community Services/p' | sed '$d' | sed '/General Rate  Residential/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
      ERCS=$(printf "$ER" | sed -n '/Residential Community Services/,/Residential Kerbside Recycling/p' | sed '$d' | sed '/Residential Community Services/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=";";}''{print}'\
	  )
      ERKR=$(printf "$ER" | sed -n '/Residential Kerbside Recycling/,/Residential Drainage Connected/p'  | sed '$d' | sed '/Residential Kerbside Recycling/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=";";}''{print}\
')
      ERDC=$(printf "$ER" | sed -n '/Residential Drainage Connected/,/Citywide Water Connected/p' | sed '$d' | sed '/Residential Drainage Connected/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
      ECWC=$(printf "$ER" | sed -n '/Citywide Water Connected/,$p' | sed '/Citywide Water Connected/d' | sed 's/,//g' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')

      ERCSV="$EGRR$ERCS$ERKR$ERDC$ECWC"
      
      echo $ID",1,"$PDCSV","$CRCSV","$RLCSV$FRCSV","$ERCSV >> ratingIDsDCC.csv;

      printf "$CLEANOP";
  fi

  if [ -n "$NODETAILS" ]
  then
      echo "No record exists"
      echo $ID",0" >> ratingIDsDCC.csv;
  fi
  
  sleep 3;
  let A=A+1
done
