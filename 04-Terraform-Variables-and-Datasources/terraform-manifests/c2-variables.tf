# Input Variables
variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 Instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_keypair" {
  description = "AWS EC2 Key Pair that need to be associated with EC2 Instance"
  type        = string
  default     = "terraform-key"
}

variable "profile" {
  description = "The name of the profile that terraform will use to interact with AWS"
  type        = string
  default     = "personal"
}