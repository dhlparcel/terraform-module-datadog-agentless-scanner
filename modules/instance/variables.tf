variable "name" {
  description = "Name prefix to be used on EC2 instance created"
  type        = string
  default     = "DatadogAgentlessScanner"
}

variable "instance_type" {
  description = "The type of instance"
  type        = string
  default     = "t4g.large"
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with"
  type        = list(string)
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource"
  type        = string
  default     = null
}

variable "monitoring" {
  description = "If true, the launched EC2 instance will have detailed monitoring enabled"
  type        = bool
  default     = false
}

variable "asg_size" {
  description = "Size of the autoscaling group the instance is in (i.e. number of instances to run)"
  type        = number
  default     = 1
}

variable "tags" {
  description = "A map of additional tags to add to the instance/volume created"
  type        = map(string)
  default     = {}
}
