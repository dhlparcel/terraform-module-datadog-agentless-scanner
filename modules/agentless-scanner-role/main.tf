locals {
  dd_tags = {
    Datadog                 = "true"
    DatadogAgentlessScanner = "true"
  }
}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "role" {
  name        = var.iam_role_name
  path        = var.iam_role_path
  description = "Role used by the Datadog Agentless-Scanner instance"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(var.tags, local.dd_tags)
}

resource "aws_iam_instance_profile" "profile" {
  role = aws_iam_role.role.name

  name = var.iam_role_name
  path = var.iam_role_path

  tags = merge(var.tags, local.dd_tags)

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "assume_policy_document" {
  statement {
    sid       = "AssumeCrossAccountScanningRole"
    effect    = "Allow"
    actions   = ["sts:AssumeRole"]
    resources = var.account_roles
  }
}

resource "aws_iam_policy" "assume_policy" {
  name   = "DatadogAgentlessScannerAgentPolicy"
  policy = data.aws_iam_policy_document.assume_policy_document.json
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = aws_iam_policy.assume_policy.arn
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "attachment" {
  count      = var.enable_ssm ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.role.name
}