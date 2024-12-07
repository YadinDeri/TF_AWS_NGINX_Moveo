output "vpc_id" {
  value = aws_vpc.this.id
}

output "subnet_ids" {
  value = aws_subnet.this[*].id
}

output "local_var_private_subnet" {
  value = [
    for subnet in aws_subnet.this : subnet.id
    if subnet.map_public_ip_on_launch == false
  ]
}

output "local_var_public_subnet" {
  value = [
    for subnet in aws_subnet.this : subnet.id
    if subnet.map_public_ip_on_launch == true
  ]
}

output "local_var_public_subnet_cidr" {
  value = [
    for subnet in aws_subnet.this : subnet.cidr_block
    if subnet.map_public_ip_on_launch == true
  ]
}