exports.handler = (event, context, callback) => {
    //console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2)) 
    //console.info("EVENT\n" + JSON.stringify(event, null, 2))

    console.info("handler.Started..");
    console.info("this is message");
    console.info("handler.Completed..");
    callback(null, "just a message");
};
