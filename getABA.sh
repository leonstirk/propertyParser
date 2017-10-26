#!/bin/bash

phantomjs --ssl-protocol=any getABA.js

cat ABA.html | pup '#snapshot, #activity, #performance, #fundamental json{}' | jq '.' > ABA.json
