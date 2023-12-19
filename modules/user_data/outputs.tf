output "install_sh" {
  description = "The installation script for the Datadog agentless scanner"
  value       = terraform_data.template.output
}