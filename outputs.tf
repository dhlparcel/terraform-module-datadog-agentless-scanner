output "vpc" {
  description = "The VPC created for the Datadog side-scanner"
  value       = module.vpc.vpc
}

output "role" {
  description = "The Datadog side-scanner role created"
  value       = module.side_scanner_role.role
}