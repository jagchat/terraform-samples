//How to test:
//do a POST request to "<url>/dev/notify" with following json content
// {
//     "product_id": "4004"
// }
//----------------
var moment = require('moment');
const AWS = require('aws-sdk');
const eventbridge = new AWS.EventBridge()

exports.handler = async (event, context, callback) => {
    console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2)) 
	console.info("EVENT\n" + JSON.stringify(event, null, 2))

    console.info("handler.Started..");

    var min = 1000;
    var max = 5000;
  
    var randomNumber = Math.floor(Math.random() * (max - min + 1)) + min;
    var payload = {
        "product_id": JSON.parse(event.body).product_id,
        "tracking_id": randomNumber
    };

    const params = {
        Entries: [ 
          {
            Detail: JSON.stringify(payload),
            DetailType: 'Message',
            EventBusName: 'jag-event-bus', //should match from eventbridge config
            Source: 'product.create', //should match from eventbridge config
            Time: new Date 
          }
        ]
    };
    
    // Publish to EventBridge
    const result = await eventbridge.putEvents(params).promise();

    var now = moment().format("dddd, MMMM Do YYYY, h:mm:ss a");
  
    var msg = {
        isBase64Encoded: false,
        body: JSON.stringify({payload, currentTime: now, result}),
        headers:{
            'Access-Control-Allow-Origin': '*'
        },
        statusCode: 200
    }
    console.info("handler.Completed..");
    callback(null, msg);
};
