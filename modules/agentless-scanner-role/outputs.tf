output "role" {
  description = "The Datadog agentless-scanner role created"
  value       = aws_iam_role.role
}

output "instance_profile" {
  description = "The Datadog agentless-scanner instance profile created"
  value       = aws_iam_instance_profile.profile
}