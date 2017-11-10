#!/bin/bash

SAT=$(date -dsaturday +%Y-%m-%d)
SUN=$(date -dsunday +%Y-%m-%d)
# 365 days/year / 2 ~= 182 days
ENDSAT=$(date -d "$SAT + 182 days" +"%Y-%m-%d")
ENDSUN=$(date -d "$SUN + 182 days" +"%Y-%m-%d")

echo $SAT
echo $SUN

until [ "$SUN" == "$ENDSUN" ]; do
  SAT=$(date -d "$SAT + 7 days" +%Y-%m-%d)
  SUN=$(date -d "$SUN + 7 days" +%Y-%m-%d)
  echo $SAT
  echo $SUN
done
