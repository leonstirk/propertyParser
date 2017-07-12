#!/bin/bash

#call time randomizer

FLATTIME=$(date "+%H%M");
RANGE=10
MINIMUM=1


if [ $FLATTIME -gt 1800 ]
then
    echo "after 8";
    RAND=$(( $RANGE * $RANDOM / 32767 + $MINIMUM))
    echo $RAND;
    sleep $RAND;
else
    echo "before 8";
fi
