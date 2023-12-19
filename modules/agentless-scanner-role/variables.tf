variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = "DatadogAgentlessScannerAgentRole"
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "account_roles" {
  description = "List of cross accounts roles ARN that the Datadog agentless scanner can assume"
  type        = list(string)
  default     = []
}

variable "secret_arn" {
  description = "ARN of the secret holding the Datadog API key"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "ARN of the KMS key encrypting the secret"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of additional tags to add to the IAM role/profile created"
  type        = map(string)
  default     = {}
}

variable "enable_ssm" {
  description = "Whether to enable AWS SSM to facilitate executing troubleshooting commands on the instance"
  type        = bool
  default     = false
}