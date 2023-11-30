output "role" {
  description = "The Datadog side-scanner role created"
  value = aws_iam_role.role
}

output "instance_profile" {
  description = "The Datadog side-scanner instance profile created"
  value = aws_iam_instance_profile.profile
}