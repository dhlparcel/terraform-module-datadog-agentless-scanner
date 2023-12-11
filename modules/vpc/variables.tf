variable "name" {
  description = "Name tag, e.g stack"
  type        = string
  default     = "DatadogSideScanner"
}

variable "cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "A map of additional tags to add to the instance/volume created"
  type        = map(string)
  default     = {}
}