var system = require('system');
var args = system.args;

var fs = require('fs');
var page = require('webpage').create();

console.log(args[1])

var url = "".concat("https://app.companiesoffice.govt.nz/companies/app/ui/pages/companies/",args[1],"/detail")

console.log(url)

page.open(url, function(status) {
    if (status !== 'success') {
        console.log('Unable to access network');
    } else {
        try {
            fs.write("./company.html", page.content, 'w');
        } catch(e) {
            console.log(e);
        }
    }
    phantom.exit();
});
