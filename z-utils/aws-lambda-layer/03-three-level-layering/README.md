# three level layering

NOTE: Need to execute `npm install` in `layer-base/nodejs` manually prior to executing Terraform script

- This terraform sample deploys two layers (base and custom)
- Custom layer refers to base layer
- Lambda function 1 uses only base layer
- Lambda function 2 uses both layers.
