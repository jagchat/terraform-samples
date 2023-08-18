//import { createRequire } from 'node:module';
//const require = createRequire(import.meta.url);

import { Consumer } from "sqs-consumer";
import { SQSClient } from '@aws-sdk/client-sqs';
import { NodeHttpHandler } from "@smithy/node-http-handler";
import http from "https";

const app = Consumer.create({
    queueUrl: 'https://sqs.us-east-2.amazonaws.com/264955239305/sample-dev-events-queue',
    handleMessage: async (message) => {
        // do some work with `message`
        console.log(message);
    },

    sqs: new SQSClient({
        region: 'us-east-2',
        // --to keep http connection alive
        // requestHandler: new NodeHttpHandler({
        //     httpAgent: new http.Agent({
        //         keepAlive: true,
        //     })
        // }),
    })
});

app.on('error', (err) => {
    console.error(err.message);
});

app.on('processing_error', (err) => {
    console.error(err.message);
});

app.on('timeout_error', (err) => {
    console.error(err.message);
});

app.start();