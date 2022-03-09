resource "aws_security_group" "webserver" {
  name = "Dynamic_Security_Group"
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

 tags = {
    Name = "${var.projectname}-SecurityGroup-WebServer"
    Owner = "${var.owner}"
    Environment = "${var.env}"
  }
}

resource "aws_security_group" "bastion" {
  name        = "Bastion Security Group"
  vpc_id = aws_vpc.main.id
  description = "Security group for EC2 instance with SSH only"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.projectname}-SecurityGroup-Bastion"
    Owner = "${var.owner}"
    Environment = "${var.env}"
  }
}