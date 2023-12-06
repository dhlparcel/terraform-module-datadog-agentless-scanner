variable "api_key" {
  description = "Specifies the API keys required by the Datadog Agent to submit vulnerabilities to Datadog"
  type        = string
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}