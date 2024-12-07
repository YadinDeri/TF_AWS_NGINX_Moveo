module "vpcs" {
  source = "./modules/vpc"

  for_each = { for vpc in var.vpcs : vpc.name => vpc }

  cidr_block           = each.value.cidr_block
  enable_dns_support   = each.value.enable_dns_support
  enable_dns_hostnames = each.value.enable_dns_hostnames
  subnets              = each.value.subnets
  tags                 = each.value.tags
  name                 = each.value.name
}


resource "aws_security_group" "private_ec2" {
  vpc_id = module.vpcs.vpc-test.vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [[for vpc, details in module.vpcs : details.local_var_public_subnet_cidr[0]][0]]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private-n-ec2-sg"
  }
}


resource "tls_private_key" "moveo_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "moveo_ec2_key" {
  key_name   = "moveo-ec2-key"
  public_key = tls_private_key.moveo_key_pair.public_key_openssh
}

module "nginx_vms" {
  source = "./modules/nginx_ec2"
  for_each = { for idx, vm in var.nginx_vms : idx => vm }

  ami_id                = each.value.ami_id
  instance_type      = each.value.instance_type
  subnet_id          = [for vpc, details in module.vpcs : details.local_var_private_subnet[0]][0]
  security_group_nginx = [aws_security_group.private_ec2.id]
  key_name = aws_key_pair.moveo_ec2_key.key_name
  tags = {
    Name = each.value.name
  }
}



module "load_balancer" {
  source = "./Modules/loadBalancer"
  public_subnets = module.vpcs.vpc-test.local_var_public_subnet
  vpc_id = module.vpcs.vpc-test.vpc_id
  instance_id = module.nginx_vms.0.instance_id
}

