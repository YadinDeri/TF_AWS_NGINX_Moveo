
resource "aws_instance" "nginx_instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  
  subnet_id = var.subnet_id
  vpc_security_group_ids = var.security_group_nginx  
  key_name = var.key_name
  
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y docker
              sudo systemctl start docker
              sudo systemctl enable docker
              docker run -d -p 80:80 yadinderi/moveo:latest
              EOF

  tags = var.tags
}

