variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = "DatadogSideScannerAgentRole"
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of additional tags to add to the IAM role/profile created"
  type        = map(string)
  default     = {}
}