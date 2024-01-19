# Get List of Availability Zones in a Specific Region
# Region is set in c1-versions.tf in Provider Block
# Datasource-1
data "aws_availability_zones" "my_azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Check if that respective Instance Type is supported in that Specific Region in list of availability Zones
# Get the List of Availability Zones in a Particular region where that respective Instance Type is supported
# Datasource-2
data "aws_ec2_instance_type_offerings" "my_ins_type" {
  for_each = toset(data.aws_availability_zones.my_azones.names)
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }
  filter {
    name   = "location"
    values = [each.key]
  }
  location_type = "availability-zone"
}


# Output-1
# Basic Output: All Availability Zones mapped to Supported Instance Types
output "output_v3_1" {
  value = {
    for az, details in data.aws_ec2_instance_type_offerings.my_ins_type : az => details.instance_types
  }
}

# Output-2
# Filtered Output: Exclude Unsupported Availability Zones
output "output_v3_2" {
  value = {
    for az, details in data.aws_ec2_instance_type_offerings.my_ins_type :
  az => details.instance_types if length(details.instance_types) != 0 }
}

# Output-3
# Filtered Output: with Keys Function - Which gets keys from a Map
# This will return the list of availability zones supported for a instance type
output "output_v3_3" {
  value = keys({ for az, details in data.aws_ec2_instance_type_offerings.my_ins_type :
  az => details.instance_types if length(details.instance_types) != 0 })
}


# Output-4 (additional learning)
# Filtered Output: As the output is list now, get the first item from list (just for learning)
output "output_v3_4" {
  value = keys({
    for az, details in data.aws_ec2_instance_type_offerings.my_ins_type :
  az => details.instance_types if length(details.instance_types) != 0 })[0]
}



/*{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Condition": {
				"StringNotEquals": {
					"aws:RequestedRegion": [
						"eu-west-2",
						"eu-west-1",
						"eu-central-1",
						"us-east-1"
					]
				},
				"ArnNotLike": {
					"aws:PrincipalARN": [
						"arn:aws:iam::*:role/AWSControlTowerExecution"
					]
				}
			},
			"Resource": "*",
			"Effect": "Deny",
			"NotAction": [
				"a4b:*",
				"acm:*",
				"aws-marketplace-management:*",
				"aws-marketplace:*",
				"aws-portal:*",
				"budgets:*",
				"ce:*",
				"chime:*",
				"cloudfront:*",
				"config:*",
				"cur:*",
				"directconnect:*",
				"ec2:DescribeRegions",
				"ec2:DescribeTransitGateways",
				"ec2:DescribeVpnGateways",
				"fms:*",
				"globalaccelerator:*",
				"health:*",
				"iam:*",
				"importexport:*",
				"kms:*",
				"mobileanalytics:*",
				"networkmanager:*",
				"organizations:*",
				"chatbot:*",
				"pricing:*",
				"route53-recovery-control-config:*",
				"route53-recovery-readiness:*",
				"route53-recovery-cluster:*",
				"route53:*",
				"route53domains:*",
				"s3:*",
				"s3:GetBucketPublicAccessBlock",
				"s3:ListAllMyBuckets",
				"s3:GetBucketLocation",
				"s3:DeleteMultiRegionAccessPoint",
				"s3:DescribeMultiRegionAccessPointOperation",
				"s3:GetMultiRegionAccess*",
				"s3:ListMultiRegionAccessPoints",
				"s3:GetStorageLensConfiguration",
				"s3:GetStorageLensDashboard",
				"s3:ListStorageLensConfigurations",
				"s3:GetAccountPublicAccessBlock",
				"s3:PutAccountPublicAccessBlock",
				"shield:*",
				"sts:*",
				"support:*",
				"trustedadvisor:*",
				"waf-regional:*",
				"waf:*",
				"wafv2:*",
				"access-analyzer:*"
			],
			"Sid": "GRREGIONDENY"
		},
		{
			"Condition": {
				"ArnNotLike": {
					"aws:PrincipalARN": "arn:aws:iam::*:role/AWSControlTowerExecution"
				}
			},
			"Action": [
				"lambda:AddPermission",
				"lambda:CreateEventSourceMapping",
				"lambda:CreateFunction",
				"lambda:DeleteEventSourceMapping",
				"lambda:DeleteFunction",
				"lambda:DeleteFunctionConcurrency",
				"lambda:PutFunctionConcurrency",
				"lambda:RemovePermission",
				"lambda:UpdateEventSourceMapping",
				"lambda:UpdateFunctionCode",
				"lambda:UpdateFunctionConfiguration"
			],
			"Resource": [
				"arn:aws:lambda:*:*:function:aws-controltower-*"
			],
			"Effect": "Deny",
			"Sid": "GRLAMBDAFUNCTIONPOLICY"
		},
		{
			"Condition": {
				"ForAllValues:StringEquals": {
					"aws:TagKeys": "aws-control-tower"
				},
				"ArnNotLike": {
					"aws:PrincipalARN": "arn:aws:iam::*:role/AWSControlTowerExecution"
				}
			},
			"Action": [
				"config:TagResource",
				"config:UntagResource"
			],
			"Resource": [
				"*"
			],
			"Effect": "Deny",
			"Sid": "GRCONFIGRULETAGSPOLICY"
		},
		{
			"Condition": {
				"ArnNotLike": {
					"aws:PrincipalArn": [
						"arn:aws:iam::*:role/AWSControlTowerExecution",
						"arn:aws:iam::*:role/stacksets-exec-*"
					]
				}
			},
			"Action": [
				"iam:AttachRolePolicy",
				"iam:CreateRole",
				"iam:DeleteRole",
				"iam:DeleteRolePermissionsBoundary",
				"iam:DeleteRolePolicy",
				"iam:DetachRolePolicy",
				"iam:PutRolePermissionsBoundary",
				"iam:PutRolePolicy",
				"iam:UpdateAssumeRolePolicy",
				"iam:UpdateRole",
				"iam:UpdateRoleDescription"
			],
			"Resource": [
				"arn:aws:iam::*:role/aws-controltower-*",
				"arn:aws:iam::*:role/*AWSControlTower*",
				"arn:aws:iam::*:role/stacksets-exec-*"
			],
			"Effect": "Deny",
			"Sid": "GRIAMROLEPOLICY"
		},
		{
			"Condition": {
				"ArnNotLike": {
					"aws:PrincipalARN": "arn:aws:iam::*:role/AWSControlTowerExecution"
				}
			},
			"Action": [
				"cloudtrail:DeleteTrail",
				"cloudtrail:PutEventSelectors",
				"cloudtrail:StopLogging",
				"cloudtrail:UpdateTrail"
			],
			"Resource": [
				"arn:aws:cloudtrail:*:*:trail/aws-controltower-*"
			],
			"Effect": "Deny",
			"Sid": "GRCLOUDTRAILENABLED"
		},
		{
			"Condition": {
				"ArnNotLike": {
					"aws:PrincipalARN": "arn:aws:iam::*:role/AWSControlTowerExecution"
				}
			},
			"Action": [
				"config:DeleteConfigurationRecorder",
				"config:DeleteDeliveryChannel",
				"config:DeleteRetentionConfiguration",
				"config:PutConfigurationRecorder",
				"config:PutDeliveryChannel",
				"config:PutRetentionConfiguration",
				"config:StopConfigurationRecorder"
			],
			"Resource": [
				"*"
			],
			"Effect": "Deny",
			"Sid": "GRCONFIGENABLED"
		},
		{
			"Condition": {
				"ArnNotLike": {
					"aws:PrincipalARN": "arn:aws:iam::*:role/AWSControlTowerExecution"
				}
			},
			"Action": [
				"sns:AddPermission",
				"sns:CreateTopic",
				"sns:DeleteTopic",
				"sns:RemovePermission",
				"sns:SetTopicAttributes"
			],
			"Resource": [
				"arn:aws:sns:*:*:aws-controltower-*"
			],
			"Effect": "Deny",
			"Sid": "GRSNSTOPICPOLICY"
		},
		{
			"Condition": {
				"ArnNotLike": {
					"aws:PrincipalARN": "arn:aws:iam::*:role/AWSControlTowerExecution"
				}
			},
			"Action": [
				"sns:Subscribe",
				"sns:Unsubscribe"
			],
			"Resource": [
				"arn:aws:sns:*:*:aws-controltower-SecurityNotifications"
			],
			"Effect": "Deny",
			"Sid": "GRSNSSUBSCRIPTIONPOLICY"
		},
		{
			"Condition": {
				"StringNotLike": {
					"aws:PrincipalArn": [
						"arn:aws:iam::*:role/AWSControlTowerExecution"
					]
				}
			},
			"Action": [
				"logs:DeleteLogGroup",
				"logs:PutRetentionPolicy"
			],
			"Resource": [
				"arn:aws:logs:*:*:log-group:*aws-controltower*"
			],
			"Effect": "Deny",
			"Sid": "GRLOGGROUPPOLICY"
		},
		{
			"Condition": {
				"StringLike": {
					"aws:ResourceTag/aws-control-tower": "managed-by-control-tower"
				},
				"ArnNotLike": {
					"aws:PrincipalArn": "arn:aws:iam::*:role/AWSControlTowerExecution"
				}
			},
			"Action": [
				"config:DeleteAggregationAuthorization"
			],
			"Resource": [
				"arn:aws:config:*:*:aggregation-authorization*"
			],
			"Effect": "Deny",
			"Sid": "GRCONFIGAGGREGATIONAUTHORIZATIONPOLICY"
		}
	]
}






{
			"Condition": {
				"ArnNotLike": {
					"aws:PrincipalArn": [
						"arn:aws:iam::*:role/AWSControlTowerExecution",
						"arn:aws:iam::*:role/stacksets-exec-*"
					]
				}
			},
			"Action": [
				"iam:AttachRolePolicy",
				"iam:CreateRole",
				"iam:DeleteRole",
				"iam:DeleteRolePermissionsBoundary",
				"iam:DeleteRolePolicy",
				"iam:DetachRolePolicy",
				"iam:PutRolePermissionsBoundary",
				"iam:PutRolePolicy",
				"iam:UpdateAssumeRolePolicy",
				"iam:UpdateRole",
				"iam:UpdateRoleDescription"
			],
			"Resource": [
				"arn:aws:iam::*:role/aws-controltower-*",
				"arn:aws:iam::*:role/*AWSControlTower*",
				"arn:aws:iam::*:role/stacksets-exec-*"
			],
			"Effect": "Deny",
			"Sid": "GRIAMROLEPOLICY"
		},
		{
			"Condition": {
				"ArnNotLike": {
					"aws:PrincipalARN": "arn:aws:iam::*:role/AWSControlTowerExecution"
				}
			},
			"Action": [
				"cloudtrail:DeleteTrail",
				"cloudtrail:PutEventSelectors",
				"cloudtrail:StopLogging",
				"cloudtrail:UpdateTrail"
			],
			"Resource": [
				"arn:aws:cloudtrail:*:*:trail/aws-controltower-*"
			],
			"Effect": "Deny",
			"Sid": "GRCLOUDTRAILENABLED"
		},
    */