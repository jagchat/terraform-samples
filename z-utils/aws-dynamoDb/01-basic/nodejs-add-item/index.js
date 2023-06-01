const aws = require('aws-sdk');
//>export AWS_ACCESS_KEY_ID=
//>export AWS_SECRET_ACCESS_KEY=
//>export AWS_REGION=
//or
//aws.config.loadFromPath('./config.json');

//if using AWS SSO
//login to AWS CLI using SSO in terminal
//>export AWS_SDK_LOAD_CONFIG=1
const { fromSSO } = require("@aws-sdk/credential-providers");
var credentials;
var loadSsoContext = async () => {
    credentials = await fromSSO({
        profile: "<aws-profile-name>"
    })();
};
const dynamoDB = new aws.DynamoDB({
    credentials: credentials,
    region: "us-east-1", // If not set, will get from ~/.aws directory or environment variable
    // and rest of properties
})

const documentClient = new aws.DynamoDB.DocumentClient({
    credentials: credentials,
    region: "us-east-2"
});

//const documentClient = new aws.DynamoDB.DocumentClient();
const moment = require('moment');
const uid = require('short-uuid');
const ulid = require('ulid');


let newUid = uid.generate();
let newUlid = ulid.ulid();
let now = moment();
let nowISO = now.toISOString();
let nowUnixEpoch = now.valueOf(); //returns number
//to delete the row automatically after 5 minutes
let ttlExpiration = now.add(5, 'minutes').valueOf(); //returns number 
let msgTypeInfo = "info";

var eventLogItemParams = {
    Item: {
        "uid": newUid,
        "ulid": newUlid,
        "TimeStamp": nowISO,
        "MessageType": msgTypeInfo,
        "ExpirationTime": ttlExpiration,
        "Message": "Trying to add a record",
        "Data": { "empno": 1001, "ename": "Jag" }
    },
    TableName: "event-log"
};
documentClient.put(eventLogItemParams, function (err, data) {
    if (err) console.log(err);
    else console.log(data);
});