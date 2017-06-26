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

PROPERTY=$(cat ./output.txt)

VALUATION=$(cat ./output.txt | sed -n '/Valuation number/{n;p;}')
RATEID=$(cat ./output.txt | sed -n '/Rate account ID/{n;p;}')
PROPERTYNO=$(cat ./output.txt | sed -n '/Property number/{n;p;}')
PROPERTYADDRESS=$(cat ./output.txt | sed -n '/Property address/{n;p;}')
POSTALADDRESS=$(cat ./output.txt | sed -n '/Postal address for this assessment/,/Current Rates/p' | sed '/Postal address for this assessment/d;/Current Rates/d' | awk 'BEGIN{RS="\n"; ORS=",";}''{print $1,$2}')

printf "$POSTALADDRESS" 
