locals {
  dd_tags = {
    Datadog            = "true"
    DatadogSideScanner = "true"
  }
}

data "aws_partition" "current" {}

// reference: https://docs.aws.amazon.com/service-authorization/latest/reference/list_amazonec2.html
data "aws_iam_policy_document" "scanning_policy_document" {
  statement {
    sid    = "DatadogSideScannerResourceTagging"
    effect = "Allow"
    actions = [
      "ec2:CreateTags"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/*",
      "arn:${data.aws_partition.current.partition}:ec2:*:*:snapshot/*",
    ]
    // Allow specifying tags when creating snapshots or volumes
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateSnapshot", "CreateVolume"]
    }
  }

  statement {
    sid    = "DatadogSideScannerVolumeSnapshotCreation"
    effect = "Allow"
    actions = [
      "ec2:CreateSnapshot",
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/*",
    ]
    // Allow creating snapshots from any volume that does not have a
    // DatadogSideScanner:false tag.
    condition {
      test     = "StringNotEquals"
      variable = "aws:ResourceTag/DatadogSideScanner"
      values   = ["false"]
    }
  }

  statement {
    sid    = "DatadogSideScannerSnapshotCreation"
    effect = "Allow"
    actions = [
      "ec2:CreateSnapshot"
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*:*:snapshot/*",
    ]
    // Enforcing created snapshot has DatadogSideScanner tag
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/DatadogSideScanner"
      values   = ["true"]
    }
    // Enforcing created snapshot has only tags with DatadogSideScanner* prefix
    condition {
      test     = "ForAllValues:StringLike"
      variable = "aws:TagKeys"
      values   = ["DatadogSideScanner*"]
    }
  }

  statement {
    sid    = "DatadogSideScannerSnapshotAccessAndCleanup"
    effect = "Allow"
    actions = [
      // Allow reading created snapshots' blocks from EBS direct APIs
      "ebs:GetSnapshotBlock",
      "ebs:ListChangedBlocks",
      "ebs:ListSnapshotBlocks",

      // Allow deleting created snapshots and volumes
      "ec2:DeleteSnapshot",

      // Allow describing created snapshots
      "ec2:DescribeSnapshotAttribute",
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:ec2:*:*:snapshot/*",
    ]

    // Enforce that any of these actions can be performed on resources
    // (volumes and snapshots) that have the DatadogSideScanner tag.
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/DatadogSideScanner"
      values   = ["true"]
    }
  }

  statement {
    sid    = "DatadogSideScannerDescribeSnapshots"
    effect = "Allow"
    actions = [
      // Required to be able to wait for snapshots completion. It cannot be
      // restricted.
      "ec2:DescribeSnapshots",
    ]
    resources = [
      "*",
    ]
  }

  # Uncomment this block to allow volume-attach mode of the scanner:
  #
  #   statement {
  #     sid   = "DatadogSideScannerSnapshotSharing"
  #     effet = "allow"
  #     actions = [
  #       // Allow sharing created snapshots for cross-account scanning
  #       "ec2:ModifySnapshotAttribute"
  #     ]
  #     resources = [
  #       "arn:${data.aws_partition.current.partition}:ec2:*:*:snapshot/*",
  #     ]
  #     condition {
  #       test     = "StringEquals"
  #       variable = "aws:ResourceTag/DatadogSideScanner"
  #       values   = ["true"]
  #     }
  #   }
  #
  #   statement {
  #     sid    = "DatadogSideScannerVolumeCreation"
  #     effect = "Allow"
  #     actions = [
  #       "ec2:CreateVolume",
  #     ]
  #     resources = [
  #       "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/*",
  #     ]
  #     // Enforcing created volume has DatadogSideScanner tag
  #     condition {
  #       test     = "StringEquals"
  #       variable = "aws:RequestTag/DatadogSideScanner"
  #       values   = ["true"]
  #     }
  #     // Enforcing created volume has only tags with DatadogSideScanner* prefix
  #     condition {
  #       test     = "ForAllValues:StringLike"
  #       variable = "aws:TagKeys"
  #       values   = ["DatadogSideScanner*"]
  #     }
  #   }
  #
  #   statement {
  #     sid    = "DatadogSideScannerVolumeAttachToInstance"
  #     effect = "Allow"
  #     actions = [
  #       "ec2:AttachVolume",
  #       "ec2:DetachVolume",
  #     ]
  #     resources = [
  #       "arn:${data.aws_partition.current.partition}:ec2:*:*:instance/*",
  #     ]
  #     // Enforce that any of these actions can be performed on resources
  #     // (volumes and snapshots) that have the DatadogSideScanner tag.
  #     condition {
  #       test     = "StringEquals"
  #       variable = "aws:ResourceTag/DatadogSideScanner"
  #       values   = ["true"]
  #     }
  #   }
  #
  #   statement {
  #     sid    = "DatadogSideScannerVolumeAttachAndDelete"
  #     effect = "Allow"
  #     actions = [
  #       "ec2:AttachVolume",
  #       "ec2:DetachVolume",
  #       "ec2:DeleteVolume",
  #     ]
  #     resources = [
  #       "arn:${data.aws_partition.current.partition}:ec2:*:*:volume/*",
  #     ]
  #     // Enforce that any of these actions can be performed on resources
  #     // (volumes and snapshots) that have the DatadogSideScanner tag.
  #     condition {
  #       test     = "StringEquals"
  #       variable = "aws:ResourceTag/DatadogSideScanner"
  #       values   = ["true"]
  #     }
  #   }

  statement {
    sid    = "GetLambdaDetails"
    effect = "Allow"
    actions = [
      "lambda:GetFunction",
    ]
    resources = [
      "arn:${data.aws_partition.current.partition}:lambda:*:*:function:*"
    ]
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
