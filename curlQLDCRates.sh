#!/bin/bash

# RATINGID="28087"
RATINGID="28086"

curl "https://services.qldc.govt.nz/eProperty/P1/eRates/RatingInformation.aspx?r=QLDC.WEB.GUEST&f=%24P1.ERA.RATDETAL.VIW&PropertyNo="$RATINGID
