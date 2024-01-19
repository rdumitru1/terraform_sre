# Terraform Output Values

# EC2 Instance Public IP
output "instance_publicip" {
  description = "EC2 Instance Public IP"
  value       = aws_instance.myec2vm.public_ip
}

output "instance_publicdns" {
  description = "Ec2 instance Public DNS"
  value       = aws_instance.myec2vm.public_dns
}