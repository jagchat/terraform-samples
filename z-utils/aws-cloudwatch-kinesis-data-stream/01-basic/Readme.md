# Inject Cloudwatch logs to Kinesis Data Stream

Please see thiis
<https://stackoverflow.com/questions/76836767/cloudwatch-subscription-filter-does-not-ingest-to-kinesis-data-stream>

Steps after deployment:

```
>aws kinesis get-shard-iterator --region us-east-2 --stream-name terraform-kinesis-test --shard-id shardId-000000000000 --shard-iterator-type LATEST
```

- execute lambda now

```
>aws kinesis get-records --region us-east-2 --limit 10 --shard-iterator "AAAAAAAAAAFJLtCiSWtIElHL2K8Mw9a+31lY7ZwH1f7rlmed2ULBXcQFr3nFcnfC8TRTn30ya6b67pdUpvl2saxNzZxbZXqsaoCyajQuNno4zOSCAYnfF9zXPC15A3FqFdp2Dm/cqhqbRfOeldgCq80nLhd5Pn6cZs62IJ07yp2PTcgQfu+4SAVud1lHEj9TCYVH0GwGas1+JGjYdvNzgnbhljVjyd4FEcvWp1GagrIuNYOCxh/oFEMTIKOT5P3Pmr4bxWNtpJU="
```

copy value from "Data" attribute in "Records" array here to see the decoded data
<https://gchq.github.io/CyberChef/#recipe=From_Base64('A-Za-z0-9%2B/%3D',true)Gunzip()>

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
