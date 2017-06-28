#!/bin/bash

# rm -f output.txt

# f='./rawHtml/0.txt';

# # delete last 2 lines in a file
# # sed 'N;$!P;$!D;$d'

# # PROPERTY=$(cat $f |  sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' | sed 's/<sup>//g;s/<\/sup>//g;s/<a//g;s/<\/a>//g' | sed '/<[A-Zb-z\/ ]*/d' | sed 's/^[ ]*//;s/[ ]*$//' | sed 's/nbsp;//g' | sed '/var/d;/>/d;/javascript/d;/href/d;/mapmode/d;/Certificate Of Title:/d;/Comments:/d;/Distance :/d' | sed '/^$/d' | sed '/:/{x;p;x;}' | grep -A 1 ':' | sed '$d' | sed 's/^$/NA/g')


# # sed 's/,//g' | sed 's/--/-/g' | awk -v ORS='' '{print}' | awk 'BEGIN{RS="-"; FS=":"; ORS="\n"; OFS=",";}''{print $1,$2}' | awk  -v FS="," -v OFS="," '{for (i=1;i<=NF;i++) a[i,NR]=$i; }END{ for(i=1;i<=NF;i++) { for(j=1;j<=NR;j++) printf "%s%s", a[i,j], (j==NR? ORS:OFS); } }')

# # Get Owner(s) Details
# OWNERS=$(cat ./rawHtml/1.txt | grep 'setFastSearch' | sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>=]//g' | awk -F'<a href=' 'BEGIN{OFS="\n";} {print $1,$2,$3;}' | grep -o '>.*<' | sed 's/<\/a><//g;s/<i>//g;s/<\/i>//g;s/>//g' | sed 's/amp;/\&/g')

# # Append OWNERS to PROPERTY
# PROPERTY=$PROPERTY'\n'$OWNERS'\n--\n';

# # printf "$PROPERTY"
# printf "$OWNERS"

# Property Details

PD=$(cat ./output.txt | sed -n '/Property Details/,/Current Rates/p');

VALUATION=$(printf "$PD" | sed -n '/Valuation number/{n;p;}');
RATEID=$(printf "$PD" | sed -n '/Rate account ID/{n;p;}')
PROPERTYNO=$(printf "$PD" | sed -n '/Property number/{n;p;}')
PROPERTYADDRESS=$(printf "$PD" | sed -n '/Property address/{n;p;}')
CERTOFTITLE=$(printf "$PD" | sed -n '/Certificate(s) of title (guide only)/{n;p;}')
RATEPAYERNAMES=$(printf "$PD" | sed -n '/Ratepayer name(s)/{n;p;}')
POSTALADDRESS=$(printf "$PD" | sed -n '/Postal address for this assessment/,/Current Rates/p' | sed '/Postal address for this assessment/d;/Current Rates/d' | awk 'BEGIN{RS="\n"; ORS=",";}''{print}')

# printf "$VALUATION $RATEID $PROPERTYNO $PROPERTYADDRESS $CERTOFTITLE $RATEPAYERNAMES $POSTALADDRESS"
# echo

# Current Rates

CR=$(cat ./output.txt | sed -n '/Current Rates/,/Rates levied/p')

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

# printf "$CURRENTRATINGYEAR $RATINGPERIOD $RATEABILITY $RATINGDIFFERENTIAL $LANDUSE $LEGALDESCRIPTION $AREA $VALUEOFIMPROVEMENTS $LANDVALUE $SEPERATEPARTS"
# echo

# Rates Levied

RL=$(cat ./output.txt | sed -n '/Rates levied/,/Show full rates breakdown/p')

HEADERS="Description,Factor,Rate or Change,Amount"
RCS=$(printf "$RL" | sed -n '/Residential Community Services/,/General Rate  Residential/p' | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
GRR=$(printf "$RL" | sed -n '/General Rate  Residential/,/Residential Kerbside Recycling/p' | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
RKR=$(printf "$RL" | sed -n '/Residential Kerbside Recycling/,/Citywide Water Connected/p'  | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
CWC=$(printf "$RL" | sed -n '/Citywide Water Connected/,/Residential Drainage Connected/p'  | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
RDC=$(printf "$RL" | sed -n '/Residential Drainage Connected/,/Show full rates breakdown/p' | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')

# printf "$RCS $GRR $RKR $CWC $RDC"
# echo

# Future Rates

FR=$(cat ./output.txt | sed -n '/Future Rates/,/Estimated Rates/p')

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

printf "$FUTURERATINGYEAR $FRATINGPERIOD $FRATEABILITY $FRATINGDIFFERENTIAL $FLANDUSE $FLEGALDESCRIPTION $FAREA $FVALUEOFIMPROVEMENTS $FLANDVALUE $FCAPITALVALUE $FSEPERATEPARTS"
echo

# Estimated Rates

ER=$(cat ./output.txt | sed -n '/Estimated Rates/,$p')

EGRR=$(printf "$ER" | sed -n '/General Rate  Residential/,/Residential Community Services/p' | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
ERCS=$(printf "$ER" | sed -n '/Residential Community Services/,/Residential Kerbside Recycling/p' | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
ERKR=$(printf "$ER" | sed -n '/Residential Kerbside Recycling/,/Residential Drainage Connected/p'  | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
ERDC=$(printf "$ER" | sed -n '/Residential Drainage Connected/,/Citywide Water Connected/p' | sed '$d' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')
ECWC=$(printf "$ER" | sed -n '/Citywide Water Connected/,$p' | awk 'BEGIN{RS="\n";ORS=";";}''{print}')

# printf "$EGRR $ERCS $ERKR $ERDC $ECWC"
# echo
