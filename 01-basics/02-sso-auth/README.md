# Create S3 bucket

A demo on how to execute terraform script using AWS SSO based authentication

#### Pre-requisites

- Ensure AWS CLI is installed and configured
- Ensure "terraform" is installed
- Only `main.tf` is required for this demo

## Usage

- Configure SSO based AWS CLI authentication locally as follows:

```bash
> aws configure sso
```

- After configuration the `.aws\config` would contain details similar to the following:

```bash
[profile sso.jag.sandbox]
sso_session = sso.jag.sandbox
sso_account_id = 123456789123
sso_role_name = AdministratorAccess
sso_start_url = https://d-123456789c.awsapps.com/start
sso_region = us-east-1
region = us-east-1
output = json
[sso-session sso.jag.sandbox]
sso_start_url = https://d-123456789c.awsapps.com/start
sso_region = us-east-1
sso_registration_scopes = sso:account:access
```

- Run following commands to login in AWS a/c using AWS SSO:

```bash
> $env:AWS_PROFILE = 'sso.jag.sandbox'
> aws sso login --profile sso.jag.sandbox
```

- Ensure we are using right AWS a/c:

```bash
> aws sts get-caller-identity
```

- Initialize terraform in the script folder. This step is needed only once to download respective provider to local folder

```bash
> terraform init
```

- Validate script

```bash
> terraform validate
```

- Format script

```bash
> terraform fmt
```

- Following command "trail" runs the script

```bash
> terraform plan
```

- Following command runs/executes the script and changes get applied to AWS environment. This will also create "state" files (terraform.tfstate.\*)locally to maintain current state of deployment and to help future deployments after modifications to scripts.

```bash
> terraform apply
```

- Following command permanently deletes the deployment (including state)

```bash
> terraform destroy
```
