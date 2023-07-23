module "layer_base" {
  source              = "terraform-aws-modules/lambda/aws"
  create_layer        = true
  layer_name          = "layer-base"
  description         = "A Sample Base Layer"
  compatible_runtimes = ["nodejs16.x", "nodejs14.x", "nodejs12.x"]
  source_path         = "${path.module}/layer-base"
}
