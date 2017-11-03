var system = require('system');
var args = system.args;

var fs = require('fs');
var page = require('webpage').create();

args.forEach(function(arg) {
    console.log(arg);
});

// var url = "".concat("https://app.companiesoffice.govt.nz/companies/app/ui/pages/companies/",variable,"/detail")

// console.log(url)

// page.open(url, function(status) {
//     if (status !== 'success') {
//         console.log('Unable to access network');
//     } else {
//         try {
//             fs.write("./companies.html", page.content, 'w');
//         } catch(e) {
//             console.log(e);
//         }
//     }
//     phantom.exit();
// });



phantom.exit()
