output "vpc" {
  description = "The VPC created for the Datadog side-scanner"
  value       = module.vpc.vpc
}