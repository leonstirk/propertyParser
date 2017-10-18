#!/bin/bash

phantomjs --ssl-protocol=any companiesScrape.js

cat test.html | pup '.dataList table tbody tr json{}' | jq '.' > companies.json
