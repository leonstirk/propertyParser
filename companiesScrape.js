var fs = require('fs');
var page = require('webpage').create();

var date = new Date();
var year = date.getFullYear().toString();
var month = date.getMonth()+1

if(month < 10) {
    month = "".concat("0",month.toString())
} else {
    month = month.toString()
}

var daye = (date.getDate()-1).toString();

if(daye < 10) {
  daye = "".concat("0",daye.toString())
} else {
  daye = daye.toString()
}

// var days = (date.getDate()-2).toString();

// if(days < 10) {
//   days = "".concat("0",days.toString())
// } else {
//   days = days.toString()
// }

// start = "".concat(days,"%2F",month,"%2F",year);
end = "".concat(daye,"%2F",month,"%2F",year);

// console.log(start)
// console.log(typeof start)
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
