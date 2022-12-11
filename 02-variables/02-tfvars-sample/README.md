# tfvars

Basic demonstration of "tfvars"
- Variable values can be supplied using a separate file `terraform.tfvars`
- In this case, a variable named `my_bucket_name` is defined `variables.tf`
- The variable is being used as part of `main.tf` using `bucket = var.my_bucket_name`
- The default value is `jag-tf-test-bucket`. however, it uses the value defined `terraform.tfvars`

### Other ways

- `terraform.tfvars` can have values as following:
```bash
my_bucket_name = "just-tf-test-bucket"
```

- Same thing can be achieved using `terraform.tfvars.json` (json format) as following:
```bash
{
    "my_bucket_name" : "just-tf-test-bucket"
}
```

* All of the following `tfvars` filenames are valid and we can use as needed:
    * terraform.tfvars
    * terraform.tfvars.json
    * SomeName.auto.tfvars
    * SomeName.auto.tfvars.json

