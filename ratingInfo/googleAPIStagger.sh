#!/bin/bash

i=$(cat index.txt)

exp="${i}q;d"

filename=$(sed $exp splitFilesList.txt)

./geocode.sh $filename

inc=$(($i+1))
echo $inc > index.txt
