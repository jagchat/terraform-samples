const aws = require('aws-sdk');
//>export AWS_ACCESS_KEY_ID=
//>export AWS_SECRET_ACCESS_KEY=
//>export AWS_REGION=
//or
//aws.config.loadFromPath('./config.json');

const ses = new aws.SES();

let params = {
    Destination: {
        ToAddresses: ["anthachetta@gmail.com"] //if using SES sandbox, configure email as SES identity
    },
    Message: {
        Body: {
            Html: {
                Charset: "UTF-8",
                Data: `<i>Sample HTML Msg</i>`
            },
            Text: {
                Charset: "UTF-8",
                Data: `Sample Text Msg`
            }
        },
        Subject: {
            Charset: "UTF-8",
            Data: `Sample Subject Msg`
        }
    },
    Source: "jag.randd@gmail.com", //configured SES identity
    ReplyToAddresses: ["jag.randd@gmail.com"]
};

var sendPromise = ses.sendEmail(params).promise();

sendPromise.then(function(data){
    console.log(data.MessageId);
    console.log("----data----");
    console.log(data);
}).catch(
    function (err){
        console.error(err, err.stack);
    }
);