variable "api_key" {
  description = "Specifies the API keys required by the Datadog Agent to submit vulnerabilities to Datadog"
  type        = string
  sensitive   = true
}

variable "site" {
  description = "By default the Agent sends its data to Datadog US site. If your organization is on another site, you must update it. See https://docs.datadoghq.com/getting_started/site/"
  type        = string
  default     = null
}

variable "scanner_version" {
  description = "Specifies the agentless scanner version installed"
  type        = string
  default     = null
}

variable "instance_profile_name" {
  description = "value"
  type        = string
}
