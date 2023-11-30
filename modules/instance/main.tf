locals {
  dd_tags = {
    Datadog     = "true"
    SideScanner = "true"
  }
}

resource "aws_instance" "instance" {
  ami           = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-arm64"
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
