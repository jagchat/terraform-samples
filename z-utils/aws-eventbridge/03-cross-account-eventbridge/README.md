# Quick Notes

This is a test a project to test cross account communication between two event buses.

The sample demonstrates following:

- central event bus receives events from tenant event bus
- central event bus writes all events to cloudwatch
- tenant event bus write all events to cloudwatch and publishes all events to central event bus
- An EC2 instance gets created at tenant account with respective permissions to put events to eventbridge (please check Readme.md of `tenant-linux-ec2` for more details)
- a node.js sample which publishes events to tenant event bus.

#### how to test

- modify `terraform.tfvars` in all folders as needed
- ensure you have two different AWS accounts (central and tenant) to test this sample.
- execute terraform in `central-account` folder first
- ensure central event bus works as expected (publish events using console and check in cloudwatch)
- use following info for publishing an event:

```
detail-type: "tenant.event.info",
source: "central.event.fromtenant",
detail: {    "a": 10  }
```

- make a note of central event bus arn
- switch to `tenant-account` folder
- provide central event bus arn at `aws_iam_policy.tenant_eventbridge_policy`
- execute terraform in `tenant-account` folder
- test tenant event bus using console
- ensure that the published event is available through cloudwatch of both central and tenant
- `tenant-linux-ec2` is used to deploy a new EC2 instance to tenant account.  Once deployed, you can upload node.js sample and execute it to test publishing of events to tenant account (which fans out to central account).  Checkout readme.md in `tenant-linux-ec2`
