var dateHelper = require('date-helper');
exports.handler = (event, context, callback) => {
    //console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2)) 
    //console.info("EVENT\n" + JSON.stringify(event, null, 2))

    console.info("handler.Started..");

    let message = dateHelper.getRandomMessage();

    console.info("handler.Completed..");
    callback(null, message);
};
