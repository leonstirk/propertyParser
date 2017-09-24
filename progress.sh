#!/bin/bash

i=0
while [ $i -lt 1 ]; do
    NUM=$(ls -l ./csv/ | wc -l)

    PC=$(bc <<< 'scale=4; ((45676+'$NUM')*100)/50691')

    printf "\r$NUM : $PC%%"

    sleep 10
done
