var system = require('system');
var args = system.args;

var fs = require('fs');
var page = require('webpage').create();

console.log(args[1])

var date = new Date(args[1]);
var year = date.getFullYear().toString();
var month = date.getMonth()+1

console.log(date)

if(month < 10) {
    month = "".concat("0",month.toString())
} else {
    month = month.toString()
}

var daye = (date.getDate()).toString();

if(daye < 10) {
  daye = "".concat("0",daye.toString())
} else {
  daye = daye.toString()
}

end = "".concat(daye,"%2F",month,"%2F",year);

console.log(end)
console.log(typeof end)



var url = "".concat("https://app.companiesoffice.govt.nz/companies/app/ui/pages/companies/search?q=&entityTypes=ALL&entityStatusGroups=ALL&incorpFrom=",end,"&incorpTo=",end,"&addressTypes=ALL&addressKeyword=&start=0&limit=1000&sf=&sd=&advancedPanel=true&mode=advanced#results")

console.log(url)

page.open(url, function(status) {
    if (status !== 'success') {
	console.log('Unable to access network');
    } else {
	try {
	    fs.write("./companies.html", page.content, 'w');
	} catch(e) {
	    console.log(e);
	}
    }
    phantom.exit();
});


// phantom.exit();
