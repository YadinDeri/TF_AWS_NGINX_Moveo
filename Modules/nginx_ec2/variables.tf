
variable "subnet_id" {
  description = "The subnet ID in which to launch the EC2 instances"
  type        = string
}

variable "security_group_nginx" {
  description = "security group"
  type        = list(string)
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the instance"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the EC2 instance"
}
variable "tags" {
  type        = map(string)
  description = "Tags to apply to the EC2 instance"
}

variable "key_name" {
  type =string  
}