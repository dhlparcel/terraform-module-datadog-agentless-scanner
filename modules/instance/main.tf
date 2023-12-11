locals {
  dd_tags = {
    Datadog            = "true"
    DatadogSideScanner = "true"
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.al2023.id
  instance_type = var.instance_type

  user_data                   = var.user_data
  user_data_replace_on_change = true

  availability_zone      = var.availability_zone
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name             = var.key_name
  iam_instance_profile = var.iam_instance_profile
  monitoring           = var.monitoring

  tags        = merge({ "Name" = var.name }, var.tags, local.dd_tags)
  volume_tags = merge({ "Name" = var.name }, var.tags, local.dd_tags)
}
