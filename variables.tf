variable "api_key" {
  description = "Specifies the API keys required by the Datadog Agent to submit vulnerabilities to Datadog."
  type        = string
}

variable "subnet_id" {
  description = "Specifies subnets_id the side-scanner agent should be installed in"
  type        = string
}