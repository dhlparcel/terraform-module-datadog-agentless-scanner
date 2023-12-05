data "aws_region" "current" {}

// Role attached to the side-scanner instance
module "side_scanner_role" {
  source = "./modules/side-scanner-role"
}

// Role assumed by the agent to perform scans
module "delegate_role" {
  source           = "./modules/scanning-delegate-role"
  scanner_role_arn = module.side_scanner_role.role.arn
}

data "aws_iam_policy_document" "assume_policy_document" {
  statement {
    sid       = "AssumeCrossAccountScanningRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = [module.delegate_role.role.arn]
  }
}

resource "aws_iam_policy" "assume_policy" {
  name   = "DatadogSideScannerAgentPolicy"
  policy = data.aws_iam_policy_document.assume_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = aws_iam_policy.assume_policy.arn
  role       = module.side_scanner_role.role.name
}

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
  iam_instance_profile = module.side_scanner_role.instance_profile.name
  subnet_id            = module.vpc.private_subnet.id
}