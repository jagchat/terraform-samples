const { faker } = require('@faker-js/faker');
exports.handler = (event, context, callback) => {
    //console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2)) 
    //console.info("EVENT\n" + JSON.stringify(event, null, 2))

    console.info("handler.Started..");

    let personMessage = faker.helpers.fake(
        'Hello {{person.prefix}} {{person.lastName}}, how are you today?'
    )

    console.info("handler.Completed..");
    callback(null, personMessage);
};
