# Create S3 bucket

Basic demonstration (and sample) to test terraform

#### Pre-requisites

- Ensure AWS CLI is installed and configured
- Ensure "terraform" is installed
- Only `main.tf` is required for this demo

## Usage

- Provide `access-key`, `secret-key` and `token` (for MFA) as needed in `main.tf`
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
