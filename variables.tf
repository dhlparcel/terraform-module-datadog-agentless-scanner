variable "subnet_ids" {
  description = "Specifies subnets_id for each regions the side-scanner agent should be installed in"
  type        = list(map(string))
}