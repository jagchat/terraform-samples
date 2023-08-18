# Quick Notes

This is a test a project to test cross account SQS access

The sample demonstrates following:

- SQS configured at central account level along with policy to provide access to other accounts
- An EC2 instance gets created at tenant account with respective permissions to access SQS (please check Readme.md of `tenant-linux-ec2` for more details)
- a node.js sample which consumes messages from central SQS queue

#### how to test

- modify `terraform.tfvars` in all folders as needed
- ensure you have two different AWS accounts (central and tenant) to test this sample.
- execute terraform in `central-account` folder first
- make a note of http url of SQS queue created above (and provide in node.js sample along region in SQSClient)
- switch to `tenant-linux-ec2` folder and execute terraform
- go through "readme.md" in `tenant-linux-ec2` folder and perform respective modifications
- send SQS messages using console (central account)
- ensure that the published message is displayed in node.js console at tenant ec2 level
