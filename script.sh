#!/bin/bash

# From PropertyGuru, copy <body> element and place into ./rawHtml/ directory.

# Get files from rawHtml

# Clear output folder
rm -f ./csv/*

FOLDER='./rawHtml/*.txt';
I=0
for f in $FOLDER
do

    NAME="$COUNTER".txt;
    
    # Get Property Summary Info
    # PROPERTY=$(cat $f |  sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' | sed 's/<sup>//g;s/<\/sup>//g;s/<a//g;s/<\/a>//g' | sed '/<[A-Zb-z\/ ]*/d' | sed 's/^[ ]*//;s/[ ]*$//' | sed 's/nbsp;//g' | sed '/var/d;/>/d;/javascript/d;/href/d;/mapmode/d;/Certificate Of Title:/d;/Comments:/d;/Distance :/d' | sed '/^$/d' | sed '/:/{x;p;x;}' | grep -A 1 ':' | sed '$d')

    PROPERTY=$(cat $f |  sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' | sed 's/<sup>//g;s/<\/sup>//g;s/<a//g;s/<\/a>//g' | sed '/<[A-Zb-z\/ ]*/d' | sed 's/^[ ]*//;s/[ ]*$//' | sed 's/nbsp;//g' | sed '/var/d;/>/d;/javascript/d;/href/d;/mapmode/d;/Certificate Of Title:/d;/Comments:/d;/Distance :/d' | sed '/^$/d' | sed '/:/{x;p;x;}' | grep -A 1 ':' | sed 'N;$!P;$!D;$d' | sed 's/^$/NA/g' | sed 's/,//g;s/\$//g' | sed 's/--/-/g' | awk -v ORS='' '{print}' | awk 'BEGIN{RS="-"; FS=":"; ORS="\n"; OFS=",";}''{print $1,$2}' | awk  -v FS="," -v OFS="," '{for (i=1;i<=NF;i++) a[i,NR]=$i; }END{ for(i=1;i<=NF;i++) { for(j=1;j<=NR;j++) printf "%s%s", a[i,j], (j==NR? ORS:OFS); } }')

    # Get Owner(s) Details
    OWNERS=$(cat ./rawHtml/1.txt| grep 'setFastSearch' | sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>=]//g' | awk -F'<a href=' 'BEGIN{OFS="\n";} {print $1,$2,$3;}' | grep -o '>.*<' | sed 's/<\/a><//g;s/<i>//g;s/<\/i>//g;s/>//g' | sed 's/amp;/\&/g')

    # Append OWNERS to PROPERTY
    # PROPERTY=$PROPERTY'\n--\n'$OWNERS;
    
    # Get Market History Summary

    # Make output file

    echo "$PROPERTY" > ./csv/$I.csv
    # Increment counter
    I=$((I+1))
    
done
