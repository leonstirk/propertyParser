#!/bin/bash

while read p; do
    ./qldcScrapeArg.sh $p
done <peptides.txt
