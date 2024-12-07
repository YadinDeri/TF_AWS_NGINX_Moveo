variable "public_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "instance_id" {
  type = string
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}