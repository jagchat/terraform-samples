# Variable

Basic demonstration of variables in terraform
- A variable can be defined within the same file or external file `variables.tf`
- In this case, a variable named `my_bucket_name` is defined `variables.tf`
- The variable is being used as part of `main.tf` using `bucket = var.my_bucket_name`

- if we use following command, it uses the default value in `variables.tf` (i.e., "Jag Test bucket")
```bash
>terraform plan
```

- if we use following command, it uses the one provided as part of command line
```bash
>terraform plan -var my_bucket_name="Just Test bucket"
```
