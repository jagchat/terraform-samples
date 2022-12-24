var moment = require('moment');
exports.handler = (event, context, callback) => {
    //console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2)) 
	//console.info("EVENT\n" + JSON.stringify(event, null, 2))

    console.info("handler.Started..");

    var min = 1;
    var max = 500;
  
    var randomNumber = Math.floor(Math.random() * (max - min + 1)) + min;
    var now = moment().format("dddd, MMMM Do YYYY, h:mm:ss a");
  
    //var message = 'Your dice throw resulted in ' + 
    //randomNumber + ' and was issued at ' + now;
  
    var msg = {
        isBase64Encoded: false,
        body: JSON.stringify({dice: randomNumber, currentTime: now}),
        headers:{
            'Access-Control-Allow-Origin': '*'
        },
        statusCode: 200
    }
    console.info("handler.Completed..");
    callback(null, msg);
};
