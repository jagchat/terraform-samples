# Inject Cloudwatch logs to Kinesis Firehose

This sample ingests logs from Cloudwatch to S3 via Kinesis Firehose.  We need to execute lambda to create log entries.

NOTE:  The ingested logs in S3 are GZipped and encoded.  We will not be able to view them directly from S3.

use following to show the data in S3 (ensure correct path of S3 file in "show.py"):

```
>export AWS_PROFILE=<your-profile-name>
or if using powershell >$env:AWS_PROFILE = '<profile-name>'
>cd show-logs-in-s3-python
>pip install boto3
>py show.py
```

## Usage

- Provide `access-key`, `secret-key` and `token` (for MFA) as needed in `main.tf`
  - If AWS configuration is available as part of `.aws/config`, we can use following command:
  ```bash
  export AWS_PROFILE=<your-profile-name>
  ```
- Initialize terraform in the script folder. This step is needed only once to download respective provider to local folder

```bash
> cd terraform
> terraform init
```

- Following command runs/executes the script and changes get applied to AWS environment. This will also create "state" files (terraform.tfstate.\*)locally to maintain current state of deployment and to help future deployments after modifications to scripts.

```bash
> terraform apply
```

- Once the AWS resources are created, open verification emails received (for both "from" and "to" emails) and ensure they are verified.

- Following node.js app sends email:

```bash
> cd ..
> cd nodejs-send-email
> npm install
> node index.js
```

- Following command permanently deletes the deployment (including state)

```bash
> cd ..
> cd terraform
> terraform destroy
```
