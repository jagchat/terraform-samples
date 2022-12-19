# New Environment - Instructions

#### IMPORTANT NOTES

`01-create-tf-state-backend.ps1`

- THIS SCRIPT IS FOR INITIALIZING A NEW TERRAFORM STATE BACKEND FOR A NEW ENVIRONMENT
- THIS SCRIPT CANNOT BE EXECUTED MORE THAN ONCE FOR THE SAME ENVIRONMENT
- ALL OTHER DEPLOYMENTS FOR THE ENVIRONMENT DEPENDS ON THIS STATE
- DESTROYING TERRAFORM STATE WOULD MAKE OTHER DEPLOYMENTS UNTRACEABLE

## Usage

#### Create TerraForm State Backend resources

```powershell
cd tf-state
```

- Create a file named `terraform.tfvars` from existing `terraform.tfvars.<existing-env-name>.backup`
- Modify `terraform.tfvars` as needed for new environment (ex: qa, sales, etc.)
- Execute the script as shown below

```powershell
cd ..
.\01-create-tf-state-backend.ps1
```

- Rename `terraform.tfvars` to new `terraform.tfvars.<new-env-name>.backup`

- logs are going to be written to `tf-state\logs`

#### Delete TerraForm State Backend resources

NOTE: DESTROYING TERRAFORM STATE WOULD MAKE OTHER DEPLOYMENTS UNTRACEABLE

```powershell
.\destroy-tf-state-backend.ps1
```
