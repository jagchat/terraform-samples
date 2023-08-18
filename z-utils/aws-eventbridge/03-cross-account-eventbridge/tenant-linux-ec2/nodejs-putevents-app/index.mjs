import { EventBridgeClient, PutEventsCommand } from "@aws-sdk/client-eventbridge";
const REGION = "us-east-2";
export const ebClient = new EventBridgeClient({ region: REGION });

// Set the parameters.
export const params = {
    Entries: [
        {
            Detail: '{ "key2": "value2", "key3": "value3" }',
            DetailType: "tenant.event.info",
            EventBusName: "sample-stage-tenant-event-bus",
            Source: "central.event.fromtenant",
        },
    ],
};

export const run = async () => {
    try {
        const data = await ebClient.send(new PutEventsCommand(params));
        console.log("Success, event sent; requestID:", data);
        return data; // For unit tests.
    } catch (err) {
        console.log("Error", err);
    }
}

run();