# SES with Email Identity Demo

This sample demonstrates on how to configure email identity in SES for sending/receiving emails.

NOTE:
- "From" email needs to be configured/verified as email identity
- "To" email  needs to be configured/verified as email identity, if using SES in sandbox env.

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
