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

module "agentless_scanner_role" {
  source = "github.com/DataDog/terraform-datadog-agentless-scanner//modules/agentless-scanner-role"

  account_roles = [module.delegate_role.role.arn]
}

module "delegate_role" {
  source = "github.com/DataDog/terraform-datadog-agentless-scanner//modules/scanning-delegate-role"

  scanner_role_arn = module.agentless_scanner_role.role.arn
}

module "agentless_scanner" {
  source = "github.com/DataDog/terraform-datadog-agentless-scanner"

  api_key               = var.api_key
  instance_profile_name = module.agentless_scanner_role.instance_profile.name
}