output "vpc" {
  description = "The VPC created for the Datadog agentless-scanner"
  value       = aws_vpc.vpc
}

output "public_subnet" {
  description = "The public subnet of the created VPC"
  value       = aws_subnet.public
}

output "private_subnet" {
  description = "The private subnet of the created VPC"
  value       = aws_subnet.private
}

output "nap_public_id" {
  description = "The public IP associated with the VPC's NAT"
  value       = aws_eip.nat.public_ip
}