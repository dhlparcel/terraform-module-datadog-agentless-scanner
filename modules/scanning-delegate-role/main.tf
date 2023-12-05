locals {
  dd_tags = {
    Datadog     = "true"
    SideScanner = "true"
  }
}

data "aws_partition" "current" {}

data "aws_iam_policy_document" "scanning_policy_document" {
  statement {
    sid    = "AllowSideScanningEBSSnapshots"
    effect = "Allow"
    actions = [
      "ebs:GetSnapshotBlock",
      "ebs:ListChangedBlocks",
      "ebs:ListSnapshotBlocks",
      "ec2:CopySnapshot",
      "ec2:CreateSnapshot",
      "ec2:CreateTags",
      "ec2:DeleteSnapshot",
      "ec2:DescribeImportSnapshotTasks",
      "ec2:DescribeSnapshotAttribute",
      "ec2:DescribeSnapshots",
      "ec2:DescribeSnapshotTierStatus",
      "ec2:ImportSnapshot"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:*:snapshot/*"
    ]
  }

  statement {
    sid       = "GetLambdaDetails"
    effect    = "Allow"
    actions   = ["lambda:GetFunction"]
    resources = ["arn:${data.aws_partition.current.partition}:lambda:*:*:function:*"]
  }
}

resource "aws_iam_policy" "scanning_policy" {
  name   = var.iam_policy_name
  path   = var.iam_policy_path
  policy = data.aws_iam_policy_document.scanning_policy_document.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.scanner_role_arn]
    }
  }
}

resource "aws_iam_role" "role" {
  name        = var.iam_role_name
  path        = var.iam_role_path
  description = "Role assumed by the Datadog Side-Scanner agent to perform scans"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json

  tags = merge(var.tags, local.dd_tags)
}

resource "aws_iam_role_policy_attachment" "attachment" {
  policy_arn = aws_iam_policy.scanning_policy.arn
  role       = aws_iam_role.role.name
}