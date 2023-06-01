//>export AWS_ACCESS_KEY_ID=
//>export AWS_SECRET_ACCESS_KEY=
//>export AWS_REGION=
//or
//aws.config.loadFromPath('./config.json');


import { DynamoDBClient } from "@aws-sdk/client-dynamodb";
import { PutCommand, DynamoDBDocumentClient } from "@aws-sdk/lib-dynamodb";
import moment from 'moment';
import uid from 'short-uuid';
import ulid from 'ulid';

//if using AWS SSO
import { fromSSO } from "@aws-sdk/credential-providers";
const client = new DynamoDBClient({
    credentials: fromSSO({ profile: "<aws-profile-name>" }),
    region: "us-east-2"
});

//const client = new DynamoDBClient({region: "us-east-1" });
const docClient = DynamoDBDocumentClient.from(client);

let newUid = uid.generate();
let newUlid = ulid.ulid();
let now = moment();
let nowISO = now.toISOString();
let nowUnixEpoch = now.valueOf(); //returns number
//to delete the row automatically after 5 minutes
let ttlExpiration = now.add(5, 'minutes').valueOf(); //returns number 
let msgTypeInfo = "info";

export const main = async () => {
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

    let command = new PutCommand(eventLogItemParams);

    let response = await docClient.send(command);
    console.log(response);
    return response;
};

await main();