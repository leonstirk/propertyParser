#!/bin/bash

curl https://app.companiesoffice.govt.nz/companies/app/ui/pages/companies/search?q=&start=0&limit=1000&entitySearch=&addressKeyword=&postalCode=&incorpFrom=20/09/2017&incorpTo=21/09/2017&country=&addressType=&advancedPanel=true&mode=advanced&sf=&sd=&entityTypes=ALL&entityStatusGroups=ALL&addressTypes=ALL | pup --color


https://app.companiesoffice.govt.nz/companies/app/ui/pages/companies/search?q=&start=0&limit=15&entitySearch=&addressKeyword=&postalCode=&incorpFrom=20/09/2017&incorpTo=21/09/2017&country=&addressType=&advancedPanel=true&mode=advanced&sf=incorporationDate&sd=desc&entityTypes=ALL&entityStatusGroups=ALL&addressTypes=ALL | 
