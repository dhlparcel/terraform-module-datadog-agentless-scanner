output "vpc" {
  description = "The VPC created for the Datadog agentless scanner"
  value       = module.vpc.vpc
}