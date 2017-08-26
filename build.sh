#!/bin/bash

A=309236
while [  $A -lt 309237 ]; do
# A=50
# while [  $A -lt 100 ]; do
  ID=$( printf '%06d' $A )

  echo $ID;
  
  WEBGET=$(curl -s http://www.dunedin.govt.nz/services/rates-information/rates?ratingID=$ID | sed -n '/dCaption">Property Details/,/ENDING RATE ACCOUNT MESSAGE/p' | sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' | sed 's/^[ \t]*//');

  NODETAILS=$(printf "$WEBGET" | sed -n '/There are no current Ratepayer details/p');
  
  if [ -z "$NODETAILS" ]
  then
      echo "Record exists";

      #hello
      
      echo $ID",1," >> ratingIDsDCC.csv;
      echo "OK";
  fi

  if [ -n "$NODETAILS" ]
  then
      echo "No record exists"
      echo $ID",0" >> ratingIDsDCC.csv;
      echo "OK";
  fi

  #call time randomizer

  FLATTIME=$(date "+%H%M");
  RANGE=10
  MINIMUM=1

  RAND=$(( $RANGE * $RANDOM / 32767 + $MINIMUM))

  echo "wait $RAND";
  sleep $RAND;
  
  let A=A+1
done
