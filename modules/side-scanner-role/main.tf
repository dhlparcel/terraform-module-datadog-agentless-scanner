locals {
  dd_tags = {
    Datadog     = "true"
    SideScanner = "true"
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
  description = "Role used by the Datadog Side-Scanner instance"

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