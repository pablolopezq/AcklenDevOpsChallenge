provider "aws" {
  region = var.region
}

data "aws_vpc" "default" {
  id = var.vpc_id
}

data "aws_internet_gateway" "gateway" {
  internet_gateway_id = var.gateway_id
}

resource "aws_subnet" "subnet_one" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = var.subnet_one_block
  availability_zone = var.zone_one
}

resource "aws_subnet" "subnet_two" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = var.subnet_two_block
  availability_zone = var.zone_two
}

resource "aws_eip" "eip_one" {
  instance                  = aws_instance.instance_one.id
  vpc                       = true
  associate_with_private_ip = aws_instance.instance_one.private_ip
}

resource "aws_eip" "eip_two" {
  instance                  = aws_instance.instance_two.id
  vpc                       = true
  associate_with_private_ip = aws_instance.instance_two.private_ip
}

resource "aws_key_pair" "key" {
  key_name   = "key"
  public_key = var.public_key
}

resource "aws_key_pair" "key_two" {
  key_name   = "key_two"
  public_key = var.public_key_two
}

resource "aws_instance" "instance_one" {
  ami             = var.image
  instance_type   = var.ec2_type
  subnet_id       = aws_subnet.subnet_one.id
  security_groups = [aws_security_group.sec_group.id]
  key_name        = aws_key_pair.key.key_name
  tags = {
    Name = "one"
  }
}

resource "aws_instance" "instance_two" {
  ami             = var.image
  instance_type   = var.ec2_type
  subnet_id       = aws_subnet.subnet_two.id
  security_groups = [aws_security_group.sec_group.id]
  key_name        = aws_key_pair.key.key_name
  tags = {
    Name = "two"
  }
}


resource "aws_lb" "app_load_balancer" {
  subnets            = [aws_subnet.subnet_one.id, aws_subnet.subnet_two.id]
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sec_group.id]
  ip_address_type    = "ipv4"
}

resource "aws_security_group" "sec_group" {
  vpc_id = data.aws_vpc.default.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "target_group_one" {
  vpc_id   = data.aws_vpc.default.id
  port     = 80
  protocol = "HTTP"
}

resource "aws_lb_target_group" "target_group_two" {
  vpc_id   = data.aws_vpc.default.id
  port     = 80
  protocol = "HTTP"
}

resource "aws_lb_target_group_attachment" "target_one" {
  target_group_arn = aws_lb_target_group.target_group_one.arn
  target_id        = aws_instance.instance_one.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "target_two" {
  target_group_arn = aws_lb_target_group.target_group_two.arn
  target_id        = aws_instance.instance_two.id
  port             = 80
}

resource "aws_lb_listener" "listener_one" {
  load_balancer_arn = aws_lb.app_load_balancer.arn
  port              = 80
  default_action {
    type = "forward"

    forward {
      target_group {
        arn = aws_lb_target_group.target_group_one.arn
      }
      target_group {
        arn = aws_lb_target_group.target_group_two.arn
      }
    }
  }
}
