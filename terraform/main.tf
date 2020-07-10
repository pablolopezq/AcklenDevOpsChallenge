provider "aws" {
  region = "us-east-2"
}

data "aws_vpc" "default" {
  id = "vpc-2193494a"
}

data "aws_internet_gateway" "gateway" {
  internet_gateway_id = "igw-936b2ffb"
}

resource "aws_subnet" "subnet_one" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.150.0/24"
  availability_zone = "us-east-2a"
}

resource "aws_subnet" "subnet_two" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = "172.31.100.0/24"
  availability_zone = "us-east-2b"
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

resource "aws_instance" "instance_one" {
  ami             = "ami-0e4c8f89e102079c1"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet_one.id
  security_groups = [aws_security_group.sec_group.id]
}

resource "aws_instance" "instance_two" {
  ami             = "ami-0e4c8f89e102079c1"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet_two.id
  security_groups = [aws_security_group.sec_group.id]
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
