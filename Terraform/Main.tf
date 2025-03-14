resource "aws_security_group" "Project-MB" {
  name        = "Project-MB"
  description = "Open 22,443,80,8080,9000,8081,9100,25,6443,3000,30000,30001,465"

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22,443,80,8080,9000,8081,9100,25,6443,3000,30000,30001,465] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Project-MB"
  }
}


resource "aws_instance" "web" {
  ami                    = "ami-04b4f1a9cf54c11d0"
  instance_type          = "t2.large"
  key_name               = "bms"
  vpc_security_group_ids = [aws_security_group.Project-MB.id]
  user_data              = templatefile("./resource.sh", {})

  tags = {
    Name = "BMS"
  }
  root_block_device {
    volume_size = 30
  }
}
