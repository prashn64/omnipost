/**
 * Wait until the test condition is true or a timeout occurs. Useful for waiting
 * on a server response or for a ui change (fadeIn, etc.) to occur.
 *
 * @param testFx javascript condition that evaluates to a boolean,
 * it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
 * as a callback function.
 * @param onReady what to do when testFx condition is fulfilled,
 * it can be passed in as a string (e.g.: "1 == 1" or "$('#bar').is(':visible')" or
 * as a callback function.
 * @param timeOutMillis the max amount of time to wait. If not specified, 3 sec is used.
 */
function waitFor(testFx, onReady, timeOutMillis) {
    var maxtimeOutMillis = timeOutMillis ? timeOutMillis : 3001, //< Default Max Timeout is 3s
        start = new Date().getTime(),
        condition = false,
        interval = setInterval(function() {
            if ( (new Date().getTime() - start < maxtimeOutMillis) && !condition ) {
                // If not time-out yet and condition not yet fulfilled
                condition = (typeof(testFx) === "string" ? eval(testFx) : testFx()); //< defensive code
            } else {
                if(!condition) {
                    // If condition still not fulfilled (timeout but condition is 'false')
                    console.log("'waitFor()' timeout");
                    phantom.exit(1);
                } else {
                    // Condition fulfilled (timeout and/or condition is 'true')
                    console.log("'waitFor()' finished in " + (new Date().getTime() - start) + "ms.");
                    typeof(onReady) === "string" ? eval(onReady) : onReady(); //< Do what it's supposed to do once the condition is fulfilled
                    clearInterval(interval); //< Stop this interval
                }
            }
        }, 100); //< repeat check every 100ms
};
//if (system.args.length !== 2) {
//    console.log('Usage: run-jasmine.js URL');
//    phantom.exit();
//}
var page = require('webpage').create();
var snapshotcommand = "snapshot";

page.onAlert = function(msg) {
  console.log(msg);
}

// Route "console.log()" calls from within the Page context to the main Phantom context (i.e. current "this")
page.onConsoleMessage = function(msg) {
    console.log(msg);
    if(msg.search(snapshotcommand) > -1) {
      page.render('images/' + msg + '.png');
    }
};
page.open("SpecRunner.html", function(status){
    if (status !== "success") {
        console.log("Unable to access network");
        phantom.exit();
    } else {
        // catch the snapshot triggers from jasmine unit tests and call console.log to actually take the snapshot.
        page.evaluate(function() {
           console.log('binding render');
           function render(event, imagepath) {
            
              console.log(imagepath + "snapshot");
           }
           $('#snapshot').bind('render', render);
        });        
        
        page.injectJs('omnipost.spec.js');
        page.injectJs('jasmine-start.js');
        
        waitFor(function(){
            return page.evaluate(function(){
                if (document.body.querySelector('.runner .description')) {
                    return true;
                }
                return false;
            });
        }, function(){
            page.evaluate(function(){
                console.log(document.body.querySelector('.description').innerText);
                list = document.body.querySelectorAll('div.jasmine_reporter > div.suite.failed');
                for (i = 0; i < list.length; ++i) {
                    el = list[i];
                    desc = el.querySelectorAll('.description');
                    console.log('');
                    for (j = 0; j < desc.length; ++j) {
                        console.log(desc[j].innerText);
                    }
                }
            });
            phantom.exit();
        });
    }
});
