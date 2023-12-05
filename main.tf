data "aws_region" "current" {}

module "vpc" {
  source = "./modules/vpc"
}

module "user_data" {
  source   = "./modules/user_data"
  hostname = "side-scanning-${data.aws_region.current.name}"
  api_key  = var.api_key
  site     = var.site
}

module "instance" {
  source               = "./modules/instance"
  user_data            = module.user_data.install_sh
  iam_instance_profile = var.instance_profile_name
  subnet_id            = module.vpc.private_subnet.id
}