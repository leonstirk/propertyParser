#!/bin/bash

curl "https://www.companiesoffice.govt.nz/companies/app/ui/pages/companies/search?q=&start=0&limit=100&entitySearch=&addressKeyword=Dunedin&postalCode=&incorpFrom=04/06/2017&incorpTo=02/07/2017&country=&addressType=&advancedPanel=true&mode=advanced&sf=&sd=&entityTypes=LTD&entityStatusGroups=REGISTERED&addressTypes=ALL" | sed 's/[^A-Za-z0-9,.:;\$\/\@\(\)\b \b<>]//g' > companies.txt


