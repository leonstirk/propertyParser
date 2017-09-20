#!/bin/bash

i=0
while [ $i -lt 1 ]; do
    NUM=$(ls -l ./csv/ | wc -l)

    PC=$(bc <<< 'scale=4; ((14995+'$NUM')*100)/30005')

    printf "\r$NUM : $PC%%"

    sleep 10
done
