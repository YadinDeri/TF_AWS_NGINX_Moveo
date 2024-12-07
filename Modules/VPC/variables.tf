variable "cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "enable_dns_support" {
  description = "Whether or not to enable DNS support"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether or not to enable DNS hostnames"
  type        = bool
  default     = true
}

variable "subnets" {
  description = "List of subnets for the VPC"
  type = list(object({
    cidr_block              = string
    availability_zone       = string
    map_public_ip_on_launch = bool
    name                    = string  
  }))
}


variable "tags" {
  description = "Tags to associate with resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of the VPC"
  type        = string
}
