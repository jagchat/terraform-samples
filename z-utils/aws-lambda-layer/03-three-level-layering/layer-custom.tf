module "layer_custom" {
  source              = "terraform-aws-modules/lambda/aws"
  create_layer        = true
  layer_name          = "layer-custom"
  description         = "A Sample Custom Layer"
  compatible_runtimes = ["nodejs16.x", "nodejs14.x", "nodejs12.x"]
  source_path         = "${path.module}/layer-custom"
  layers              = [module.layer_base.lambda_layer_arn]
}
