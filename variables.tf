variable "vpcs" {
  description = "List of VPC configurations"
  type = list(object({
    name                 = string
    cidr_block           = string
    enable_dns_support   = bool
    enable_dns_hostnames = bool
    subnets = list(object({
      name                    = string
      cidr_block              = string
      availability_zone       = string
      map_public_ip_on_launch = bool
    }))
    tags = map(string)
  }))
}



variable "nginx_vms" {
  description = "List of VM definitions with ami_id, instance_type, and name"
  type = list(object({
    ami_id        = string
    instance_type = string
    name          = string
  }))
}

