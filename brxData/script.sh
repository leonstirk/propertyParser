#!/bin/bash

MONGOPASS="i08wh37Y"

atlasimport() {

db=$1
coll=$2
file_name=$3

# file_name=`dirname $(pwd)`/`basename $(pwd)`/$file

mongoimport --host Cluster0-shard-0/cluster0-shard-00-00-gyynp.mongodb.net:27017,cluster0-shard-00-01-gyynp.mongodb.net:27017,cluster0-shard-00-02-gyynp.mongodb.net:27017 --ssl --username leonstirk --password $MONGOPASS --authenticationDatabase admin --db $db --collection $coll --type json --file $file_name --jsonArray
}

# atlasimport test test companies/05Jan2018.json

for file_name in ~/propertyParser/brxData/companies/*.json; do
  atlasimport test test $file_name
done
