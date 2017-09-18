#!/bin/bash

i=0
while [ $i -lt 1 ]; do
    NUM=$(ls -l ./csv/ | wc -l)

    PC=$(bc <<< 'scale=2; ('$NUM'*100)/37507')

    printf "\r$NUM : $PC%%"

    sleep 10
done
