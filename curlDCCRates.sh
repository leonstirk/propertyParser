#!/bin/bash

A=331940
while [  $A -lt 331941 ]; do
  ID=$( printf '%06d' $A )

  # PROPERTY=$(curl http://www.dunedin.govt.nz/services/rates-information/rates?ratingID=$ID | sed -n '/dCaption">Property Details/,/ENDING RATE ACCOUNT MESSAGE/p' | sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' | sed 's/^[ \t]*//' | sed -e 's/<[^>]*>//g' | sed '/Top of this page/d;/Property Details/d;/Click the link below/d;/The Rates Breakdown provided/d;/The gross general rate column/d;/investments in Councilowned companies/d;/o give the net general rate/d;/function toggleBreak/d;/divT/d;/If you wish to object to your valuation/d' | sed '/^$/d')

  curl http://www.dunedin.govt.nz/services/rates-information/rates?ratingID=$ID | sed -n '/dCaption">Property Details/,/ENDING RATE ACCOUNT MESSAGE/p' | sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' | sed 's/^[ \t]*//' | sed 's/<br \/>/; /g' | sed -e 's/<[^>]*>//g' | sed '/Top of this page/d;/Click the link below/d;/The Rates Breakdown provided/d;/The gross general rate column/d;/investments in Councilowned companies/d;/o give the net general rate/d;/function toggleBreak/d;/divT/d;/If you wish to object to your valuation/d' | sed '/^$/d' > output.txt
  
  let A=A+1
done





