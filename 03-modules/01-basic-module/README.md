# Module

- The root folder (where we run `terraform plan`) is typically called a "root" module
- A Terraform Module is a container for multiple resources that are used together
- It is typically created in a separate folder with its own structure (main.tf, variables.tf etc.)
- It is imported/used in root module (or other modules) by referring it (we still run only root module)
- The modules can be nested
