//sample POST body
//--------
// {
//     "a": 10,
//     "b": 20
// }
//--------
exports.handler = (event, context, callback) => {
    //console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2)) 
	console.info("EVENT\n" + JSON.stringify(event, null, 2))

    console.info("handler.Started..");

    var payload = JSON.parse(event.body);
    var c = payload.a + payload.b;

    var msg = {
        isBase64Encoded: false,
        body: JSON.stringify({result: c}),
        headers:{
            'Access-Control-Allow-Origin': '*'
        },
        statusCode: 200
    }
    console.info("handler.Completed..");
    callback(null, msg);
};
