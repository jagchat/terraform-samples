module "sample_layer_lambda_layer" {
  source              = "terraform-aws-modules/lambda/aws"
  create_layer        = true
  layer_name          = "sample-layer"
  description         = "A Sample Layer"
  compatible_runtimes = ["nodejs16.x", "nodejs14.x", "nodejs12.x"]
  source_path         = "${path.module}/sample-layer/date-helper"
}
