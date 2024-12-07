output "vpc_ids" {
  value = { for vpc, details in module.vpcs : vpc => details.vpc_id }
}

output "subnet_ids" {
  value = { for vpc, details in module.vpcs : vpc => details.subnet_ids }
}

output "priavte_subnet_ids" {
  value = { for vpc, details in module.vpcs : vpc => details.local_var_private_subnet }
}

output "public_subnet_ids" {
  value = { for vpc, details in module.vpcs : vpc => details.local_var_public_subnet }
}

output "public_subnet_cidr" {
  value = { for vpc, details in module.vpcs : vpc => details.local_var_public_subnet_cidr }
}

output "sg_out_id" {
  value = aws_security_group.private_ec2.id
}

output "applb_dns" {
  value = module.load_balancer.alb_dns
}


output "private_key_pem" {
  value     = tls_private_key.moveo_key_pair.private_key_pem
  sensitive = true
}

output "public_key" {
  value = tls_private_key.moveo_key_pair.public_key_openssh
}
