terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "side_scanner_role" {
  source = "github.com/DataDog/terraform-datadog-sidescanner//modules/side-scanner-role"

  account_roles = [module.delegate_role.role.arn]
}

module "delegate_role" {
  source = "github.com/DataDog/terraform-datadog-sidescanner//modules/scanning-delegate-role"

  scanner_role_arn = module.side_scanner_role.role.arn
}

module "user_data" {
  source = "github.com/DataDog/terraform-datadog-sidescanner//modules/user_data"

  hostname = "side-scanning-us-east-1"
  api_key  = var.api_key
}

module "instance" {
  source = "github.com/DataDog/terraform-datadog-sidescanner//modules/instance"

  user_data            = module.user_data.install_sh
  iam_instance_profile = module.side_scanner_role.profile.name
  subnet_id            = var.subnet_id
}