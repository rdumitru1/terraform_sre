# Get DNS information from AWS Route53
data "aws_route53_zone" "mydomain" {
  name = "devopscookbook.net"
}

# Output MyDomain Zone ID
output "my_domain_zoneid" {
  description = "The Hosted Zone id"
  value       = data.aws_route53_zone.mydomain.zone_id
}

# Output MyDomain name
output "mydomain_name" {
  description = " The Hosted Zone name of the desired Hosted Zone."
  value       = data.aws_route53_zone.mydomain.name
}
