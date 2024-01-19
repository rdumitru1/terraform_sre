# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t2.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key Pair that need to be associated with EC2 Instance"
  type        = string
  default     = "terraform-key"
}

variable "instance_type_list" {
  description = "EC2 Instance Type"
  type        = list(string)
  default     = ["t2.micro", "t3.micro", "t3.small"]
}

variable "instance_type_map" {
  description = "EC2 Instance Type"
  type        = map(string)
  default = {
    "dev"  = "t2.micro"
    "qa"   = "t3.micro"
    "prod" = "t3.small"
  }
}