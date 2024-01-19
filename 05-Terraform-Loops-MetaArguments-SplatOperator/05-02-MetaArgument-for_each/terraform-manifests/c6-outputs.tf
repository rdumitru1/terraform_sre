# Terraform Output Values


# EC2 Instance Public IP with TOSET
output "instance_publicip" {
  description = "EC2 Instance Public IP"
  # value       = aws_instance.myec2vm[*].public_ip
  value = toset([for instance in aws_instance.myec2vm : instance.public_ip])
}

# EC2 Instance Public DNS with TOSET
output "instance_publicdns" {
  description = "EC2 Instance Public DNS"
  # value       = aws_instance.myec2vm[*].public_dns
  value = toset([for instance in aws_instance.myec2vm : instance.public_dns]) # toset is optional, you can use it without toset. toset is used to convert the returned values to the same type.
}

# EC2 Instance Public DNS with TOMAP
output "instance_publicdns2" {
  value = tomap({ for az, instance in aws_instance.myec2vm : az => instance.public_dns }) # tomap is optional, you can use it without tomap. tomap is used to convert the returned values to the same type.
}

output "instance_as_map" {
  value = { for az in aws_instance.myec2vm : az.id => az }
}


/*
# Additional Important Note about OUTPUTS when for_each used
1. The [*] and .* operators are intended for use with lists only. 
2. Because this resource uses for_each rather than count, 
its value in other expressions is a toset or a map, not a list.
3. With that said, we can use Function "toset" and loop with "for" 
to get the output for a list
4. For maps, we can directly use for loop to get the output and if we 
want to handle type conversion we can use "tomap" function too 
*/

