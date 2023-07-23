var dateHelper = require('date-helper');
const { faker } = require('@faker-js/faker');
exports.handler = (event, context, callback) => {
    //console.log("ENVIRONMENT VARIABLES\n" + JSON.stringify(process.env, null, 2)) 
    //console.info("EVENT\n" + JSON.stringify(event, null, 2))

    console.info("handler.Started..");

    let randomMessage = dateHelper.getRandomMessage();
    let personMessage = faker.helpers.fake(
        'Hello {{person.prefix}} {{person.lastName}}, how are you today?'
    )
    personMessage += randomMessage;
    console.info("handler.Completed..");
    callback(null, personMessage);
};
