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

resource "aws_key_pair" "key_one" {
  key_name   = "key_one"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNBcyBmya/8tSwi8nlchOgJs4vDAybxtKjj5UKOxVWCyUXOlELq5q05sM29mGkzdVovSTDxguZv11A4P+96cjCRRXDyeZg/ea7akBVJjv7cJSE1jT9rmw42TZ88NSApmogl4mjnFidgPISASgu4SbRFIBQQFtfR3Ge8e2J1DTvEiJY6gGUpo5pMpbHgMmaaOx3+KgFXdL+r0JVu61/vh3w+CNE36teQclw2LsuHSQUMSfcKKwQIp96YGD3g3oWhRLv31TnTwXS8kFOUHb6+HcdjhV8UxgYfLO747gBoH5xt1XDh9gvLmd2eHKaQCFRkbb8jB4O/XB9l8CZhAtxGw7J6ce0vXL5Z1Q/+V2S+50WP2aEYoObl7X6dQxg9mzzDjdZenc27JDizxoK9ZFopX2Z4pw32p0AwjuRYkZGSrmNWcHIu9K4d0GWL657wCl5y37pLa+9Qi5lbLFIW9DAOj+W5IiJ6aoFM606M2yQ2ceLMmQS1ks81fys3GmaDRdpsjs= pablo@wall-e"
}

resource "aws_key_pair" "key_two" {
  key_name   = "key_two"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCxhc/MmYv3vD+VQ93kGLGeWVRD9SvQzLBidu+eRo20X03ex9vIWFvwD4+NzMMRyAZqwKCtvqniXb/nwIFmXyJjn7+WUddkN0HCTC8lxjhxOJxdSofg/7JMlrU1oyzpbW+WWi9BokqqMRKUhMgYWQDycZAq9h2eGasAlT1TPYM727iIoCOMd4AM0pa5bK5G/c7LrivZlqG+f6+ajta2arS+qR0JGBW2wMRTzEgC8iGhMIsW7iNlSpEScs4BBtU7biQeRs4MnCs9a7Ecv6GXAS5yah6UbkYVe1HoNE66YJUNoCL4qdLVPSgzPW/M0CzeLTNxILI1UW4qp9D3C2lDz6fYH0yUAMQMJVMSEJyLOBfQNk0MTgtzz8VUCRpsGDxfwwrpPGy5j0w6e09jmsdFHxDFntVZLnQHMj3c0RRc3htu29+H4t/4N5Dv+9lttQaRwzUUqPiqTqjBmSDHZBKhbRXwizMAIGUUFnK49Vft+UH8e9eOlnUc7wq8tLZy3qgLbSU= pablo@wall-e"
}

resource "aws_instance" "instance_one" {
  ami             = "ami-007e9fbe81cfbf4fa"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet_one.id
  security_groups = [aws_security_group.sec_group.id]
  key_name        = aws_key_pair.key_one.key_name
}

resource "aws_instance" "instance_two" {
  ami             = "ami-007e9fbe81cfbf4fa"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.subnet_two.id
  security_groups = [aws_security_group.sec_group.id]
  key_name        = aws_key_pair.key_two.key_name
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
