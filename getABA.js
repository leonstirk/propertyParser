var fs = require('fs');
var page = require('webpage').create();

var url = "https://www.nzx.com/instruments/RYM"

console.log(url)

page.open(url, function(status) {
    if (status !== 'success') {
        console.log('Unable to access network');
    } else {
        try {
            fs.write("./ABA.html", page.content, 'w');
        } catch(e) {
            console.log(e);
        }
    }
    phantom.exit();
});

