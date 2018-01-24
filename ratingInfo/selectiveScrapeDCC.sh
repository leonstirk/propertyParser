#!/bin/bash

while read p; do
    ./dccScrapeArg.sh $p
done < repair.txt
